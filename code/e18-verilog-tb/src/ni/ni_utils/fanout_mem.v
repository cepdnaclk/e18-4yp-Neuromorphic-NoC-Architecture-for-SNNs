// A module in the network interface that stores the fanout connections

module fanout_mem(
    input [NUM_BITS_ADDR-1:0] source_neuron_address,
    output reg [ADDRSIZE-1:0] dest_neuron_address 
); 

    parameter NUM_BITS_ADDR = 12;
    parameter NEURONS = 1024;           // The number of neurons in an accelerator
    parameter NUM_CONNECTIONS = 5;

    parameter ADDRSIZE = NUM_BITS_ADDR * NUM_CONNECTIONS;            // The number of address bits needed to identify a neuron x 5 
                                        // For all 5 downstream neurons

    localparam total_connections = NUM_CONNECTIONS * 1000; 
    
    reg [12:0] neuron_index [0:NEURONS];                // The first array of the CSR
                                                        // Needs 13 bits for atleast 5000 connections 

    reg [ADDRSIZE-1:0] downstream_neurons [0:total_connections];    
                                                        // Storing downstream addresses for each neuron 
                                                        // Assuming an average of 5 connections per nueron

    // Values for each index in row pointer
    // reg INDEX_VALUES [0:10] = {
    //     13'd0, 13'd3, 13'd5, 13'd8, 13'd11, 13'd14, 13'd17, 13'd18, 13'd23, 13'd25, 13'd28 
    // };

    // Assign neuron addresses and connections
    initial begin 

        // Neuron indices for each neuron to check the corresponding downstream neurons
        neuron_index[0] = 13'd0;
        neuron_index[1] = 13'd3;
        neuron_index[2] = 13'd5;
        neuron_index[3] = 13'd8;
        neuron_index[4] = 13'd10;
        neuron_index[5] = 13'd12;
        neuron_index[6] = 13'd14;
        neuron_index[7] = 13'd15;
        neuron_index[8] = 13'd17;
        neuron_index[9] = 13'd18;
        neuron_index[10] = 13'd19;

        // Neuron 0
        downstream_neurons[0] = 12'd3;
        downstream_neurons[1] = 12'd5;
        downstream_neurons[2] = 12'd7;

        // Neuron 1
        downstream_neurons[3] = 12'd4;
        downstream_neurons[4] = 12'd6;

        // Neuron 2
        downstream_neurons[5] = 12'd4;
        downstream_neurons[6] = 12'd5;
        downstream_neurons[7] = 12'd6;

        // Neuron 3
        downstream_neurons[8] = 12'd8;
        downstream_neurons[9] = 12'd9;

        // Neuron 4
        downstream_neurons[10] = 12'd8;
        downstream_neurons[11] = 12'd9;

        // Neuron 5
        downstream_neurons[12] = 12'd8;
        downstream_neurons[13] = 12'd9;

        // Neuron 6
        downstream_neurons[14] = 12'd9;

        // Neuron 7
        downstream_neurons[15] = 12'd8;
        downstream_neurons[16] = 12'd9;
        
        // Outputs
        // Neuron 8
        // downstream_neurons[17] = 12'd9;

        // Neuron 9
        // downstream_neurons[18] = 12'd9;

    end
    
    integer k;
    reg [NUM_BITS_ADDR-1:0] temp_array [0:NUM_CONNECTIONS-1];
    // Determine the output
    always@(source_neuron_address) begin 
        dest_neuron_address = 60'bxx;
        temp_array[0] = 12'bxx; temp_array[1] = 12'bxx; temp_array[2] = 12'bxx; temp_array[3] = 12'bxx;
        // Get the indices of where the downstream neuron addresses are stored.
        k = 0;
        for (integer i = neuron_index[source_neuron_address]; i < neuron_index[source_neuron_address+1]; i= i+1) begin 
            // temp_output = {temp_output, downstream_neurons[i]};
            // dest_neuron_address[(k+NUM_BITS_ADDR-1)+:k] = downstream_neurons[i];
            temp_array[k] = downstream_neurons[i];
            k=k+1;
        end

        #1 dest_neuron_address = {temp_array[0], temp_array[1], temp_array[2], temp_array[3], temp_array[4]};
    end


endmodule
