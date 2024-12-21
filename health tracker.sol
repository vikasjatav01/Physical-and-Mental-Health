// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PhysicalAndMentalHealth {
    struct User {
        string name;
        uint256 age;
        string gender;
        string healthGoal;
        bool exists;
    }

    struct HealthRecord {
        uint256 date;
        string activity;
        string notes;
    }

    mapping(address => User) private users;
    mapping(address => HealthRecord[]) private healthRecords;

    event UserRegistered(address indexed userAddress, string name, uint256 age, string gender, string healthGoal);
    event HealthRecordAdded(address indexed userAddress, uint256 date, string activity, string notes);

    modifier userExists() {
        require(users[msg.sender].exists, "User not registered.");
        _;
    }

    function registerUser(string memory name, uint256 age, string memory gender, string memory healthGoal) public {
        require(!users[msg.sender].exists, "User already registered.");
        users[msg.sender] = User({
            name: name,
            age: age,
            gender: gender,
            healthGoal: healthGoal,
            exists: true
        });
        emit UserRegistered(msg.sender, name, age, gender, healthGoal);
    }

    function addHealthRecord(uint256 date, string memory activity, string memory notes) public userExists {
        healthRecords[msg.sender].push(HealthRecord({
            date: date,
            activity: activity,
            notes: notes
        }));
        emit HealthRecordAdded(msg.sender, date, activity, notes);
    }

    function getUserDetails(address userAddress) public view returns (string memory, uint256, string memory, string memory) {
        User memory user = users[userAddress];
        require(user.exists, "User not registered.");
        return (user.name, user.age, user.gender, user.healthGoal);
    }

    function getHealthRecords(address userAddress) public view returns (HealthRecord[] memory) {
        require(users[userAddress].exists, "User not registered.");
        return healthRecords[userAddress];
    }
}

