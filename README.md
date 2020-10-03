# Cache-Design-VERILOG
Design of a memory sub system with cache memory using verilog hardware description language. You can implement this in an FPGA. 

## Specifications
  1. Size                  - 512kB
  2. Mappping              - Direct Mapping
  3. Write Policy          - Write Through
  4. Cache Line Size       - 8 words
  5. No of Cache Lines     - 64
  6. Replacement Algorithm - None
  
  ### Simulation Results (using Isim simulator)
  #### Read data when data not available in cache - Empty cache line 
  ![image 1](https://github.com/damithkawshan/Cache-Design-VERILOG/blob/master/simulation%20results/data%20not%20in%20cache.png)
  #### Read data when data available in cache
  ![image 2](https://github.com/damithkawshan/Cache-Design-VERILOG/blob/master/simulation%20results/data%20in%20cache.png)
   #### Read data when data not available in cache - Tag mismatch
  ![image 3](https://github.com/damithkawshan/Cache-Design-VERILOG/blob/master/simulation%20results/no_data_valid_line.png)
   #### Write data when data not available in cache - Empty cache line 
  ![image 4](https://github.com/damithkawshan/Cache-Design-VERILOG/blob/master/simulation%20results/write_data_not_exist_cline.png)
  #### Write data when data available in cache - Same cache line 
  ![image 5](https://github.com/damithkawshan/Cache-Design-VERILOG/blob/master/simulation%20results/write_data_existing_cache_line_same_addr.png)
  

  
