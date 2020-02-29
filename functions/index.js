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

exports.saveConversationIdsToUsers = functions.firestore.document('conversations/{conversationId}').onCreate((snapshot, context) => {
    const docData = snapshot.data();

    console.log('participant 1: ' + docData.participant1);
    console.log('participant 2: ' + docData.participant2);
    console.log('conversationId: ' + context.params.conversationId);

    var json1 = {};
    var json2 = {};
    json1[docData.participant2] = context.params.conversationId;
    json2[docData.participant1] = context.params.conversationId;
    
    return db.doc('/users/'+docData.participant1).set(
        {'conversationsMap': json1}, {merge: true})
        .then((value) => {
            db.doc('/users/'+docData.participant2).set({
                'conversationsMap': json2}, {merge: true});
        });
});