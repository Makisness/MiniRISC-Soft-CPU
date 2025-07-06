ISA = {
    'NOP': 0b000,
    'ADD': 0b001,
    'SUB': 0b010,
    'LOAD': 0b011,
    'STORE': 0b100,
    'JUMP': 0b101,
    'JZ': 0b110,
    'HALT': 0b111
}

REGS = {
    'R0': 0b00,
    'R1': 0b01,
    'R2': 0b10,
    'R3': 0b11
}

def assemble_line(line):
    
    #Remove commas and split lines
    tokens = line.strip().replace(',','').split()

    #Skip if blank
    if not tokens:
        return None
    
    #Formatting operation "load" -> "LOAD"
    instr = tokens[0].upper()

    if instr == "NOP": #NOP = 00000111, output 11100000
        return ISA[instr] << 5
    
    if instr == "ADD":
        rdst = tokens[1].upper()
        rsrc = tokens[2].upper()
        return (ISA[instr] << 5) | (REGS[rdst] << 3) | REGS[rsrc]
    
    if instr == "SUB":
        rdst = tokens[1].upper()
        rsrc = tokens[2].upper()
        return (ISA[instr] << 5) | (REGS[rdst] << 3) | REGS[rsrc]
    
    if instr == "LOAD":
        rdst = tokens[1].upper()
        addr = int(tokens[2])
        if addr > 7:
            print(f"Warning: Address {addr} is too large — truncating to {addr & 0b111}")
        return (ISA[instr] << 5) | (REGS[rdst] << 3) | (addr & 0b111)
    
    if instr == "STORE":
        rdst = tokens[1].upper()
        addr = int(tokens[2])
        if addr > 7:
            print(f"Warning: Address {addr} is too large — truncating to {addr & 0b111}")
        return (ISA[instr] << 5) | (REGS[rdst] << 3) | (addr & 0b111)
    
    if instr == "JUMP":
        addr = int(tokens[1])
        return (ISA[instr] << 5) | (addr & 0b11111)
    
    if instr == "JZ":
        rdst = tokens[1].upper()
        addr = int(tokens[2])
        return (ISA[instr] << 5) | (REGS[rdst] << 3) | (addr & 0b111)
    
    if instr == "HALT":
        return ISA[instr] << 5
    
    raise ValueError(f"Unknown or invalid instruction: {line}")