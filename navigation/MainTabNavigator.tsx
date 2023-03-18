import React from "react";
import { createBottomTabNavigator } from "@react-navigation/bottom-tabs";
import Icon from 'react-native-vector-icons/MaterialCommunityIcons';
import GroupList from "../components/GroupList";
import CreateGroup from "../components/CreateGroup";
import JoinGroup from "../components/JoinGroup";
// import AddFriends from "./AddFriends";

const Tab = createBottomTabNavigator();

const MainTabNavigator = () => {
  return (
    <Tab.Navigator
      screenOptions={({ route }) => ({
        tabBarIcon: ({ focused, color, size }) => {
          let iconName = "";

          switch (route.name) {
            case 'CurrentGroups':
              iconName = focused ? 'account-group' : 'account-group-outline';
              break;
            case 'CreateGroup':
              iconName = focused ? 'plus-circle' : 'plus-circle-outline';
              break;
            case 'JoinGroup':
              iconName = focused ? 'account-multiple-plus' : 'account-multiple';
              break;
            case 'AddFriends':
              iconName = focused ? 'account-plus' : 'account';
              break;
            default:
              break;
          }

          return <Icon name={iconName} size={size} color={color} />;
        },
      })}
      // tabBarOptions={{
      //   activeTintColor: "blue",
      //   inactiveTintColor: "gray",
      // }}
    >
      <Tab.Screen name="CurrentGroups" component={GroupList} />
      <Tab.Screen name="CreateGroup" component={CreateGroup} />
      <Tab.Screen name="JoinGroup" component={JoinGroup} />
      {/* <Tab.Screen name="AddFriends" component={AddFriends} /> */}
    </Tab.Navigator>
  );
};

export default MainTabNavigator;
