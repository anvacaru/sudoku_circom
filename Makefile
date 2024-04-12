# Define the build directory
BUILD_DIR := .build
INPUT_FILE := $(shell pwd)/src/input.json
TEXT_ENTROPY := "Hello World"
# Default rule for building a circuit from a .circom file
%.proof:
	@$(MAKE) CIRCOM_FILE=$* BUILD_JS_DIR=$(BUILD_DIR)/$*_js build-circom ceremony-run

# Compile Circom files for a given project
build-circom: $(BUILD_DIR)/$(CIRCOM_FILE).r1cs $(BUILD_DIR)/$(CIRCOM_FILE).wasm $(BUILD_DIR)/$(CIRCOM_FILE).sym
	@echo "Built $(CIRCOM_FILE) successfully."

# Directory creation
$(BUILD_DIR) $(BUILD_DIR)/$(CIRCOM_FILE)_js:
	mkdir -p $@

# Rule for compiling Circom files
$(BUILD_DIR)/$(CIRCOM_FILE).r1cs $(BUILD_DIR)/$(CIRCOM_FILE).wasm $(BUILD_DIR)/$(CIRCOM_FILE).sym: $(CIRCOM_FILE).circom | $(BUILD_DIR) $(BUILD_DIR)/$(CIRCOM_FILE)_js
	circom $(CIRCOM_FILE).circom --r1cs --wasm --sym -o $(BUILD_DIR)

# Ceremony workflow
ceremony-run:
	node $(BUILD_JS_DIR)/generate_witness.js $(BUILD_JS_DIR)/$(CIRCOM_FILE).wasm $(INPUT_FILE) witness.wtns 
	snarkjs powersoftau new bn128 12 pot12_0000.ptau -v 
	echo $(TEXT_ENTROPY) | snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v
	snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v 
	snarkjs groth16 setup $(BUILD_DIR)/$(CIRCOM_FILE).r1cs pot12_final.ptau $(CIRCOM_FILE)_0000.zkey 
	echo $(TEXT_ENTROPY) | snarkjs zkey contribute $(CIRCOM_FILE)_0000.zkey $(CIRCOM_FILE)_0001.zkey --name="1st Contributor Name" -v 
	snarkjs zkey export verificationkey $(CIRCOM_FILE)_0001.zkey verification_key.json 
	snarkjs groth16 prove $(CIRCOM_FILE)_0001.zkey witness.wtns proof.json public.json

clean:
	rm -rf $(BUILD_DIR) *.zkey *.ptau *.wtns *.json

.PHONY: build-circom ceremony-run clean
