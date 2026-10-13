# SPI Slave with Single-Port RAM

## 1. Project Overview

- Implements an SPI slave connected to a synchronous single-port RAM.
- Receives SPI commands and data through `MOSI`.
- Sends read data through `MISO`.
- Uses an active-low reset signal, `rst_n`.
- The main design wrapper is `SPI_Wrapper`.

## 2. Main Files

- `SPI_Slave.V`: SPI slave controller and command state machine.
- `RAM.V`: Synchronous single-port RAM controller.
- `SPI_Wrapper.V`: Connects the SPI slave to the RAM.
- `SPI_Wrapper_tb.V`: Simulation testbench.
- `Wrapper_sim_only.do`: ModelSim simulation script.
- `Execute.do`: ModelSim script that adds internal SPI and RAM signals to the waveform window.
- `Constraints_project2.xdc`: FPGA pin assignments and clock constraints for the Basys3 board.
- `Netlist.v`: Generated Vivado netlist.
- `SPI_Wrapper.bit`: Generated FPGA bitstream.

## 3. SPI Command Format

Each command is identified by the two most significant bits of the received 10-bit word:

- `00`: Set the RAM write address.
- `01`: Write data to the selected RAM address.
- `10`: Set the RAM read address.
- `11`: Read data from the selected RAM address.

The lower eight bits contain the address or data value, depending on the command.

## 4. Main Signals

- `MOSI`: SPI data input.
- `MISO`: SPI data output.
- `SS_n`: Active-low SPI slave select.
- `clk`: System clock.
- `rst_n`: Active-low reset.

## 5. Simulation

1. Open ModelSim or Questa ModelSim.
2. Change the working directory to this project folder.
3. Run the wrapper simulation script:

   ```tcl
   do Wrapper_sim_only.do
   ```

4. Use `Execute.do` when internal SPI slave and RAM signals are needed in the waveform view.

The testbench runs the write and read command sequences and stops after completing the checks.

## 6. FPGA Implementation

1. Create or open a Vivado project for the target FPGA board.
2. Add the Verilog source files:
   - `RAM.V`
   - `SPI_Slave.V`
   - `SPI_Wrapper.V`
3. Set `SPI_Wrapper` as the top module.
4. Add `Constraints_project2.xdc`.
5. Run synthesis, implementation, and bitstream generation.
6. Program the board using the generated `.bit` file.

## 7. Notes

- `Netlist.v` and `SPI_Wrapper.bit` are generated files.
- The RAM contains 256 locations, each storing 8-bit data.
- Keep the SPI clock and reset behavior consistent with the constraints and testbench.
