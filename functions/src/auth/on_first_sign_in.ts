import * as admin from 'firebase-admin';
const db = admin.firestore();

export async function saveDetails(user : admin.auth.UserRecord) {
    // add auth data to the user doc 
    await db.doc('/users/'+user.uid).set({
        'displayName': user.displayName,
        'photoURL': user.photoURL
    });
}


