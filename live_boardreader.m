% % Set the log file for BrainFlow's logging messages
addpath("/Users/aarooshbalakrishnan/Downloads/matlab_package (2)/brainflow/inc");
addpath("/Users/aarooshbalakrishnan/Downloads/matlab_package (2)/brainflow/lib");
addpath("/Users/aarooshbalakrishnan/Downloads/matlab_package (2)/brainflow");

% starts logging
    BoardShim.set_log_file('brainflow.log');
    BoardShim.enable_dev_board_logger();
    
    
    %reading from board
    params = BrainFlowInputParams();
    params.serial_port = "/dev/cu.usbmodem11";
    board_shim = BoardShim(BoardIds.GANGLION_BOARD, params);
    preset = int32(BrainFlowPresets.DEFAULT_PRESET);
    board_shim.prepare_session();
    board_shim.add_streamer('file://data_default.csv:w', preset);
    board_shim.start_stream(45000, '');
    pause(5);
    board_shim.stop_stream();
    data = board_shim.get_current_board_data(10000, preset);  %can change to alter how much you read live
    board_shim.release_session;
    BoardShim.disable_board_logger;
    
    
    %changing data format
    data=data';
    data=data(:,2:5);
    
    %filtering
    sampling_rate = BoardShim.get_sampling_rate(int32(BoardIds.GANGLION_BOARD), preset);
    filtered_data = DataFilter.perform_lowpass(data, 200, 50.0, 3, int32(FilterTypes.BUTTERWORTH), 0.0);
    
    
    % % for graphing:
    % 
    % numColumns = size(filtered_data, 2);
    % 
    % 
    % for i = 1:numColumns
    %     figure; % Create a new figure for each plot
    %     plot(filtered_data(:, i));
    %     title(['Plot of Column ', num2str(i+1)]);
    %     xlabel('Index'); % Assuming the x-axis represents some index
    %     ylabel('Value'); % Replace with your actual quantity if needed
    % end
    
    save('new.mat', 'filtered_data');
    

