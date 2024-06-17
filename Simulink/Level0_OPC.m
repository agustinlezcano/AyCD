function [output_data] = Level0_OPC(input)
persistent init_server;
persistent init_nodes;
persistent uaClient;
persistent var_node_in local_node_in;
persistent START RESET P_BEH wd_signal flagSobrecarga sobrevel_t sobrevel_h flagFDChLimSup flagFDChLimInf flagFDCtLimInf flagFDCtLimSup;
persistent pBRKEh pBRKh pBRKt M_BAL Emergencia;
persistent pBRKEhValue pBRKhValue pBRKtValue M_BALValue EmergenciaValue;

if isempty(init_server)
    disp("init 0")
    init_server = 0;
    init_nodes = 0;
    pBRKEh = 0;
    pBRKh = 0;
    pBRKt = 0;
    M_BAL = 0;
    Emergencia = 0;
end

if init_server == 0
    disp("init server")
    init_server = 1;
    uaClient = opcua('localhost',4840);
    connect(uaClient,'agustin', 'agustin');
end

if uaClient.isConnected == 1 && init_nodes == 0
    disp("init nodes")
    init_nodes = 1;
    % OPC nodes
    var_node_in = findNodeByName(uaClient.Namespace,'GLOBAL', '-once');
    local_node_in = findNodeByName(uaClient.Namespace,'NIVEL_0', '-once');
    % Inputs Level 0
    flagFDChLimSup = findNodeByName(local_node_in,'flagFDChLimSup','-once');
    flagFDChLimInf = findNodeByName(local_node_in,'flagFDChLimInf','-once');
    flagFDCtLimInf = findNodeByName(local_node_in,'flagFDCtLimInf','-once');
    flagFDCtLimSup = findNodeByName(local_node_in,'flagFDCtLimSup','-once');
    RESET = findNodeByName(local_node_in,'RESET','-once');
    % Global Inputs
    flagSobrecarga = findNodeByName(var_node_in,'flagSobrecarga','-once');
    sobrevel_h = findNodeByName(var_node_in,'sobrevel_h','-once');
    sobrevel_t = findNodeByName(var_node_in,'sobrevel_t','-once');
    P_BEH = findNodeByName(var_node_in,'P_BEH','-once');
    START = findNodeByName(var_node_in,'START','-once');
    wd_signal = findNodeByName(var_node_in,'wd_signal','-once');
    
    % Level 0 Outputs
%     Level_0_Output__Nodes = findNodeByName(uaClient.Namespace,'NIVEL_0','-once');
    pBRKEh = findNodeByName(local_node_in,'pBRKEh','-once');
    pBRKh = findNodeByName(local_node_in,'pBRKh','-once');
    pBRKt = findNodeByName(local_node_in,'pBRKt','-once');
    M_BAL = findNodeByName(var_node_in,'M_BAL','-once');
    Emergencia = findNodeByName(local_node_in,'Emergencia','-once');
    
end

if uaClient.isConnected == 1 && init_nodes == 1
    disp("Read and write")
    % Read values from OPC server (CODESYS)
    [pBRKEhValue,~,~] = readValue(uaClient,pBRKEh);
    [pBRKhValue,~,~]=readValue(uaClient,pBRKh);
    [pBRKtValue,~,~]=readValue(uaClient,pBRKt);
    [M_BALValue,~,~]=readValue(uaClient,M_BAL);
    [EmergenciaValue,~,~]=readValue(uaClient,Emergencia);
    
    disp("ini");
%     % Write values to OPC server (CODESYS)
    writeValue(uaClient,P_BEH,{input(1)}); %P_BEH
    writeValue(uaClient,START,{input(2)});
    writeValue(uaClient,sobrevel_h,{input(3)});
    writeValue(uaClient,sobrevel_t,{input(4)});
    writeValue(uaClient,flagSobrecarga,{input(5)});
    writeValue(uaClient,flagFDChLimInf,{input(6)});
    writeValue(uaClient,flagFDChLimSup,{input(7)});
    writeValue(uaClient,flagFDCtLimSup,{input(8)});
    writeValue(uaClient,flagFDCtLimInf,{input(9)});
    writeValue(uaClient,RESET,{input(10)});
    writeValue(uaClient,wd_signal,{input(11)});
    
end

disp("Output")
output_data = double([pBRKEhValue pBRKhValue pBRKtValue M_BALValue EmergenciaValue]);
disp(output_data)
end