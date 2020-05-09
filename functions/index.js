// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firestore.
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();

exports.saveDetailsOnFirstSignIn = functions.auth.user().onCreate((user) => {
    return db.doc('/users/'+user.uid).set({
        'displayName': user.displayName,
        'email': user.email,
        'photoURL': user.photoURL, 
        'phoneNumber': user.phoneNumber
    });
});

exports.addConversationsToUsers = functions.firestore.document('conversations/{conversationId}').onCreate((snapshot, context) => {
    const docData = snapshot.data();

    var i;
    const promises = [];
    for(i = 0; i < docData.uids.length; i++) {
        const uid = docData.uids[i];
        const promise = db.collection('users/'+uid+'/conversation-items')
            .add({  conversationId: snapshot.id, 
                    uids: docData.uids, 
                    displayNames: docData.displayNames, 
                    photoURLs: docData.photoURLs
                });
        promises.push(promise);
    }

    return promises;
});