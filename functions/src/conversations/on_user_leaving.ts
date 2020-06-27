import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
const db = admin.firestore();

export async function updateConversation(snapshot : functions.firestore.DocumentSnapshot, context : functions.EventContext) {

    ///////////////////////////////////////////////////////////////////////
    // remove the user from the conversation 
    ///////////////////////////////////////////////////////////////////////

    // get the document data 
    const conversationDocRef = db.collection('conversations').doc(context.params.conversationId);
    const conversationData = (await conversationDocRef.get()).data();

    if(conversationData === undefined) {
        console.error("(await db.collection('conversations').doc(context.params..conversationId).get()).data() was undefined");
        return;
    }

    // find the index of the leaving user and delete their entry in each list
    const index = conversationData.uids.indexOf(context.params.userId);
    conversationData.uids.splice(index, 1);
    conversationData.photoURLs.splice(index, 1);
    conversationData.displayNames.splice(index, 1);

    // overwrite the old doc data with the updated version
    await conversationDocRef.set(conversationData);

    ///////////////////////////////////////////////////////////////////////
    // add a message that the user left 
    ///////////////////////////////////////////////////////////////////////

    // add a message indicating user has left the conversation
    await db.collection('conversations/'+context.params.conversationId+'/messages').add({
        authorId: context.params.userId,
        text: 'And... I\'m out!',
        timestamp: admin.firestore.FieldValue.serverTimestamp()
    });
    
}