
Cell Painting Gallery Download Tool
===================================

This repository contains a set of scripts helpful for downloading the
contents of the CellPainting gallery on AWS OpenData.

The tool will create a HTCondor DAG where there is a single job per
'measurement' (approximately 75GB of data).  The job will download
the files in the measurement, bundle them into a zipfile, and then
copy the resulting zipfile to a shared filesystem.

Prerequisites
=============

0.  Checkout this git repository onto a HTCondor AP.
1.  Download the MinIO client, the tool we will use for moving files
    from AWS:

    ```
    curl https://dl.min.io/client/mc/release/linux-amd64/mc > mc
    chmod +x mc
    ```
2.  Create a "measurements file", containing one line per S3 prefix you want to
    download.  A reference `measurements.txt` is provided in this repo.

    For a set of objects with the following prefix:

    ```
    s3://cellpainting-gallery/cpg0016-jump/source_9/images/20211103-Run16/images/GR00004417/
    ```

    the corresponding entry in the file is:

    ```
    cellpainting-gallery/cpg0016-jump/source_9/images/20211103-Run16/images/GR00004417/
    ```

    Note: there will be one HTCondor job per line in this file.

Running the Download Tool
=========================

To run the tool, invoke the `cellpainting-download` script:

```
./cellpainting-download submit --max-running 15 -d /mnt/cephfs/projects/bbockelm/cellpainting-gallery --working-dir cp_dl_1 --instance cp-dl-1
```

The command-line options are:

- `-d`: The destination directory for the zip'd measurement files.  This must be mounted on the worker nodes.
- `--working-dir`: A directory name for the state files and debugging info for the jobs.
- `--instance`: An instance name for the run.
- `--max-running`: The maximum number of running downloads.  Many filesystems can't manage an unbounded number of
  transfers; use `max-running` to avoid overloads.  A good value of `--max-running` would be 30.

