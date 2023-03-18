import React, { useState } from 'react';
import { View, Text } from 'react-native';
import { Input, Button } from '@rneui/themed';
import { getDoc, doc, updateDoc, arrayUnion } from 'firebase/firestore';
import { auth, db } from '../firebaseConfig'; // Import the 'auth' and 'db' instances from your firebase.ts or firebase.js file

const JoinGroup = () => {
  const [groupId, setGroupId] = useState('');

  const joinGroup = async () => {
    try {
      const groupRef = doc(db, 'groups', groupId);
      const groupSnapshot = await getDoc(groupRef);

      if (!groupSnapshot.exists()) {
        console.error('No such group exists!');
        return;
      }

      await updateDoc(groupRef, {
        members: arrayUnion(auth.currentUser.uid),
      });

      console.log('User successfully joined the group:', groupId);
      setGroupId('');
    } catch (error) {
      console.error('Error joining group:', error);
    }
  };

  return (
    <View>
      <Text>Join a group</Text>
      <Input
        label="Group ID"
        value={groupId}
        onChangeText={(text) => setGroupId(text)}
      />
      <Button title="Join Group" onPress={joinGroup} />
    </View>
  );
};

export default JoinGroup;
