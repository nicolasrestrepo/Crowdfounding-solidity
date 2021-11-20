// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract CrowFounding {
    
    struct Contribution {
        address contributor;
        uint value;
    }
    
    struct Project {
        string id;
        string name;
        string description;
        address payable authorWallet;
        bool isOpen;
        uint founds;
        uint fundraisInGoal;
        address owner;
    }
    
    Project[] public projects;
    
    mapping( string => Contribution[]) public contributions;
    
    constructor(
        string memory _id, 
        string memory _name, 
        string memory _description,
        uint _fundraisInGoal
    ){
        Project memory project = Project(_id, _name, _description, payable(msg.sender), true, 0, _fundraisInGoal, msg.sender);
        
        projects.push(project);
    }
    
    // events
    
    event FundProjectEvent(
        address contributorWallet,
        uint ammount
    );
    
    event ChangeProjectNameEvent(
        address editor,
        string newName
    );
    
    event CreateProjectEvent(
        string id,
        string name,
        address owner
    );
    // modifiers
    
    modifier isOwner(uint projectIndex){
        require(
            projects[projectIndex].owner == msg.sender,
            "Only the owner can make this action"
        );
        
        _;
    }
    
    modifier isNotTheOwner(uint projectIndex){
        require(
            projects[projectIndex].owner != msg.sender,
            "The owner cannot contribute to his own project"
        );
        
        _;
    }
    
    function createProject(
        string memory _id, 
        string memory _name, 
        string memory _description,
        uint _fundraisInGoal   
    ) public {
        Project memory project = Project(_id, _name, _description, payable(msg.sender), true, 0, _fundraisInGoal, msg.sender);
        
        projects.push(project);
        
        emit CreateProjectEvent(_id, _name, msg.sender);
    }
    
    function fundProject(uint projectIndex) public payable isNotTheOwner(projectIndex) {
        
        Project memory project = projects[projectIndex];
         
        require(project.isOpen == true, 'The project should be open to can contribute');
        require(msg.value > 0, 'The value should be more of 0');

        project.authorWallet.transfer(msg.value);
        
        projects[projectIndex] = project;
        
        if(project.isOpen){
            
        project.founds += msg.value;
        
            emit FundProjectEvent(msg.sender, msg.value);
        }

        if(project.founds >= project.fundraisInGoal) {
            project.isOpen = false;
        }
    }
    
    function changeProjectName(uint projectIndex, string memory _newProjectName) public isOwner(projectIndex){
        Project memory project = projects[projectIndex];
         
        project.name = _newProjectName;
        
        emit ChangeProjectNameEvent(msg.sender, _newProjectName);
    }
    
}