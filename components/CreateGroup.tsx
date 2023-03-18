// components/CreateGroup.js
import React, { useState } from "react";
import { View } from "react-native";
import { Input, Button } from "@rneui/themed";
import { addDoc, collection } from 'firebase/firestore';
import { db } from "../firebaseConfig";
import { useAuth } from "../AuthProvider";

const CreateGroup = () => {
  const currentUser = useAuth()!;
  const [groupName, setGroupName] = useState("");

  const createGroup = async () => {
    try {
      const docRef = await addDoc(collection(db, 'groups'), {
        name: groupName,
        createdAt: new Date(),
      });
      console.log(`Group created with ID: ${docRef.id}`);
      setGroupName('');
    } catch (error) {
      console.error('Error creating group:', error);
    }
  };

  return (
    <View>
      <Input
        label="Group Name"
        placeholder="Enter group name"
        value={groupName}
        onChangeText={setGroupName}
      />
      <Button title="Create Group" onPress={createGroup} />
    </View>
  );
};

export default CreateGroup;
