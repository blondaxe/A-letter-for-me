// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MessageStorage {
    struct Message {
        string content;
        uint256 releaseDate;
    }

    mapping(address => Message[]) private userMessages;

    event MessageStored(address indexed user, string content, uint256 releaseDate);

    function storeMessage(string memory _content, uint256 _releaseDate) external {
        require(_releaseDate > block.timestamp, "Release date must be in the future");
        
        Message memory newMessage = Message({
            content: _content,
            releaseDate: _releaseDate
        });

        userMessages[msg.sender].push(newMessage);
        emit MessageStored(msg.sender, _content, _releaseDate);
    }

    function getMessages() external view returns (string[] memory, uint256[] memory) {
        uint256 messageCount = userMessages[msg.sender].length;

        string[] memory contents = new string[](messageCount);
        uint256[] memory releaseDates = new uint256[](messageCount);

        for (uint256 i = 0; i < messageCount; i++) {
            contents[i] = userMessages[msg.sender][i].content;
            releaseDates[i] = userMessages[msg.sender][i].releaseDate;
        }

        // Filtrer les messages en fonction de la date de libération
        for (uint256 i = 0; i < messageCount; i++) {
            if (releaseDates[i] > block.timestamp) {
                // Si la date de libération est future, masquer le contenu
                contents[i] = "";
            }
        }

        return (contents, releaseDates);
    }


    function deleteMessage(uint256 index) external {
    require(index < userMessages[msg.sender].length, "Invalid index");

    // Vérifier si la date de libération est déjà passée
    require(userMessages[msg.sender][index].releaseDate <= block.timestamp, "Release date has not passed");

    // Supprimer le message à l'indice spécifié
    for (uint256 i = index; i < userMessages[msg.sender].length - 1; i++) {
        userMessages[msg.sender][i] = userMessages[msg.sender][i + 1];
    }
    userMessages[msg.sender].pop();
    }

}
