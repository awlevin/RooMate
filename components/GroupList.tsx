import React, { useState, useEffect } from 'react';
import { View, Text } from 'react-native';
import { ListItem } from '@rneui/themed';
import { getDocs, query, collection, orderBy } from 'firebase/firestore';
import { db } from '../firebaseConfig'; // Import the 'db' instance from your firebase.ts or firebase.js file

const GroupList = () => {
  const [groups, setGroups] = useState([]);

  useEffect(() => {
    const fetchGroups = async () => {
      try {
        const q = query(collection(db, 'groups'), orderBy('createdAt', 'desc'));
        const querySnapshot = await getDocs(q);
        const fetchedGroups = querySnapshot.docs.map((doc) => ({
          id: doc.id,
          ...doc.data(),
        }));
        setGroups(fetchedGroups);
      } catch (error) {
        console.error('Error fetching groups:', error);
      }
    };

    fetchGroups();
  }, []);

  return (
    <View>
      <Text>Groups:</Text>
      {groups.map((group) => (
        <ListItem key={group.id} bottomDivider>
          <ListItem.Content>
            <ListItem.Title>{group.name}</ListItem.Title>
          </ListItem.Content>
        </ListItem>
      ))}
    </View>
  );
};

export default GroupList;
