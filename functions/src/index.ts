import * as admin from 'firebase-admin';
admin.initializeApp();

export { acceptInvite } from './onAcceptInvite';
export { declineInvite } from './onDeclineInvite';
export { inviteUser } from './inviteUser';
export { inviteUsers } from './inviteUsers';
export { createGroup } from './createGroup';
export { leaveGroup } from './onLeaveGroup';
