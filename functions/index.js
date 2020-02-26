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
