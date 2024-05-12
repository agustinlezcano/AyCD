function [output_data] = Level_1_Client_OPC(input)
persistent init_server;
persistent init_nodes;
persistent uaClient;
persistent var_node_in;
persistent xt;
persistent yl xl Select_TLK AUTO;
persistent StartPB PL;

if isempty(init_server)
    disp("init 0")
    init_server = 0;
    init_nodes = 0;
end

if init_server == 0
    disp("init server")
    init_server = 1;
    uaClient = opcua('localhost',4840);
    % setSecurityModel(uaClient, 'Best') --> se usa una vez al principio
    connect(uaClient,'agustin', 'agustin');
end

if uaClient.isConnected == 1 && init_nodes == 0
    disp("init nodes")
    init_nodes = 1;
    % OPC nodes
    var_node_in = findNodeByName(uaClient.Namespace,'GLOBAL');
    % Inputs
    xl = findNodeByName(var_node_in,'xl','-once');
    yl = findNodeByName(var_node_in,'yl','-once');
    xt = findNodeByName(var_node_in,'xt','-once');
    AUTO = findNodeByName(var_node_in,'AUTO','-once');
    Select_TLK = findNodeByName(var_node_in,'Select_TLK','-once');
    % Level 1 Outputs
    Level_0_Nodes = findNodeByName(uaClient.Namespace,'Nivel0','-once');
    StartPB = findNodeByName(Level_0_Nodes,'StartPB','-once');
    PL = findNodeByName(Level_0_Nodes,'PL','-once');
end

if uaClient.isConnected == 1 && init_nodes == 1
    disp("Read and write")
    % Read values from OPC server (CODESYS)
    [StartPB,~,~] = readValue(uaClient,StartPB);
    [PL,~,~]=readValue(uaClient,PL);
    disp("ini");
    % Write values to OPC server (CODESYS)
    writeValue(uaClient,yl,input(1)); % (1)
    writeValue(uaClient,xl,input(2));
    writeValue(uaClient,xt,input(3));
    writeValue(uaClient,AUTO,input(4));
    writeValue(uaClient,Select_TLK,input(5));
    
end

disp("Output")
output_data = double([PL, StartPB]);
disp(output_data)
end