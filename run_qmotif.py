import subprocess
import sys

bam_file = sys.argv[1]
bai_file = sys.argv[2]
log_file = sys.argv[3]
output_txt = sys.argv[4]
output_bam = sys.argv[5]
terminal_output = sys.argv[6]

command = [
    "qmotif", "-i", "qmotif.ini",
    "--bam", bam_file,
    "-bai", bai_file,
    "--log", log_file,
    "-o", output_txt,
    "-o", output_bam
]
subprocess.run(command)

grep_command = f"grep 'INCLUDES' {log_file} | awk '{{print $6\"\\t\"$22\"\\t\"$26}}' > {terminal_output}"
subprocess.run(grep_command, shell=True)
