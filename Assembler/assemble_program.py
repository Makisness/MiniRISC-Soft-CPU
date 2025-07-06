from assembler import assemble_line
def main():

    with open("Assembler/program.asm", "r") as f:
        lines = f.readlines()

    machine_code = []

    for line in lines:
        # Ignore blank lines or comments
        if line.strip() == '' or line.strip().startswith(';'):
            continue

        # Convert line to binary instruction
        byte = assemble_line(line)
        machine_code.append(byte)

    with open("./program.hex", "w") as f:
        for byte in machine_code:
            f.write(f"{byte:02X}\n")

    print("Assembly complete. Output written to program.hex")

if __name__ == "__main__":
    main()