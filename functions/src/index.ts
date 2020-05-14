import * as functions from 'firebase-functions';

// The Firebase Admin SDK to access the Firestore.
import * as admin from 'firebase-admin';
admin.initializeApp();
const db = admin.firestore();

export const saveDetailsOnFirstSignIn = functions.auth.user().onCreate((user) => {
    return db.doc('/users/'+user.uid).set({
        'displayName': user.displayName,
        'email': user.email,
        'photoURL': user.photoURL, 
        'phoneNumber': user.phoneNumber
    });
});

// we use the conversationId for the conversationItemId so that a conversation item can be identified in any context where we have the 
// conversation id and the relevant user id
export const addConversationItems = functions.firestore.document('conversations/{conversationId}').onCreate((snapshot, context) => {
    let docData = snapshot.data();
    
    if(docData == undefined) return;

    let promises = [];
    for(var i = 0; i < docData.uids.length; i++) {
        let uid = docData.uids[i];
        let promise = db.doc('users/'+uid+'/conversation-items/'+context.params.conversationId).set({
            uids: docData.uids, 
            displayNames: docData.displayNames, 
            photoURLs: docData.photoURLs
        });
        promises.push(promise);
    }

    return promises;
});

// when a user leaves a conversation, update the conversation and the other user's conversation items 
export const updateConversationItems = functions.firestore.document('users/{userId}/conversation-items/{conversationItemId}').onDelete(async (snapshot, context) => {
    
    // Get an object representing the document prior to deletion
    let deletedDocData = snapshot.data();

    if(deletedDocData == undefined) {
        console.error('snapshot.data() was undefined');
        return;
    } 

    ///////////////////////////////////////////////////////////////////////
    // remove the user from the conversation 
    ///////////////////////////////////////////////////////////////////////

    // get the document data 
    let conversationDocRef = db.collection('conversations').doc(deletedDocData.conversationId);
    let conversationData = (await conversationDocRef.get()).data();

    if(conversationData == undefined) {
        console.error("(await db.collection('conversations').doc(deletedDocData.conversationId).get()).data() was undefined");
        return;
    }

    // find the index of the leaving user and delete their entry in each list
    let index = conversationData.uids.indexOf(context.params.userId);
    conversationData.uids.splice(index, 1);
    conversationData.photoURLs.splice(index, 1);
    conversationData.displayNames.splice(index, 1);

    // we push all promises into a list that is returned by the updateConversationItems function
    let promises = [];

    // push the promise returned by the set 
    promises.push(conversationDocRef.set(conversationData));

    ///////////////////////////////////////////////////////////////////////
    // add a message that the user left 
    ///////////////////////////////////////////////////////////////////////

    // add a message indicating user has left the conversation
    let promiseToAddMessage = db.collection('conversations/'+deletedDocData.conversationId+'/messages').add({
        authorId: context.params.userId,
        text: 'And... I\'m out!',
        timestamp: admin.firestore.FieldValue.serverTimestamp()
    });
    promises.push(promiseToAddMessage);

    ///////////////////////////////////////////////////////////////////////
    // update the participant's conversation items
    ///////////////////////////////////////////////////////////////////////

    // update the conversation-items of the other participants 
    let remainingIds = conversationData.uids;
    for(var i = 0; i < remainingIds.length; i++) {
        let participantId = remainingIds[i];
        let convItemRef = db.doc('users/'+participantId+'/conversation-items/'+deletedDocData.conversationId);
        let convItemData = (await convItemRef.get()).data();
        
        if(convItemData == undefined) {
            console.error("doc at 'users/'+uid+'/conversation-items/'+deletedDocData.conversationId was undefined");
            return;
        }
        
        // find the index of the uid 
        let removalIndex = convItemData.uids.indexOf(context.params.userId);

        let promise = convItemRef.update({
            uids: convItemData.uids.splice(removalIndex,1), 
            displayNames: convItemData.displayNames(removalIndex,1), 
            photoURLs: convItemData.photoURLs(removalIndex,1)
        });
        promises.push(promise);
    }

    return promises;
    
});
