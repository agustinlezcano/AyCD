function [mass, isStable] = estimadorMasa(forceInput, errorThreshold, maxSamples)
    persistent forceBuffer;
    persistent numSamples;

    % Initialize persistent variables
    if isempty(forceBuffer)
        forceBuffer = zeros(maxSamples, 1); % Buffer to store force samples
        numSamples = 0;
    end
    % Buffer size for calculating mean
    bufferSize = length(forceBuffer);
    % Store force sample in the buffer
    numSamples = numSamples + 1;
    forceBuffer(mod(numSamples - 1, bufferSize) + 1) = forceInput;
    % Calculate the mean of all force samples
    forceMean = mean(forceBuffer(1:min(numSamples, bufferSize)));
    % Check if the difference is within the error threshold
    isStable = abs(forceInput - forceMean) < errorThreshold;
    % Calculate mass using tension formula (you may need to adjust this based on your setup)
    gravity = 9.81; % gravitational acceleration
    mass = forceInput / gravity;

end

%     if isElevating
%         % Store force sample in the buffer
%         numSamples = numSamples + 1;
%         forceBuffer(mod(numSamples - 1, bufferSize) + 1) = forceInput;
% 
%         % Calculate the mean of all force samples
%         forceMean = mean(forceBuffer(1:min(numSamples, bufferSize)));
% 
%         % Check if the difference is within the error threshold
%         isStable = abs(forceInput - forceMean) < errorThreshold;
%     else
%         % If not elevating, reset the buffer and sample count
%         forceBuffer = zeros(100, 1);
%         numSamples = 0;
% 
%         % Assume stable when not elevating
%         isStable = true;
%     end
% 
%     % Calculate mass using tension formula (you may need to adjust this based on your setup)
%     gravity = 9.81; % gravitational acceleration
%     mass = forceInput / gravity;
