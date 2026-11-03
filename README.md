# hscli-scripts

Small shell scripts using the Hammerspace CLI.

## alligned.sh

Checks whether files are aligned with Hammerspace objectives using `hs usage alignment`. It checks every 5 seconds, reports the aligned file count and percentage, and exits when all tracked files are aligned. This can be used to monitor data prestaging to a target location before running a job.

Requires Bash and a configured Hammerspace CLI (`hs`).

### Usage

```bash
bash alligned.sh /path/to/files
```

The path defaults to `./testfiles` if omitted. To run the script directly, first make it executable with `chmod +x alligned.sh`.

### Example

```text
[root@linux-admin ~]# ./alligned.sh .
2026-11-03 10:18:22 Aligned: 2/2 files (100.0%)
2026-11-03 10:18:22 All files aligned.
```

The total is the highest observed sum of aligned and partially aligned files. Files still awaiting alignment are represented by the difference between the total and aligned counts.
