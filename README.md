# bacteria-fingerprints
Using the base percentage fingerprint of the 10-mer decomposition of genomic and plasmid DNA to classify bacteria strains


##INSTALL JELLYFISH
Our analysis requires the use of jellyfish to count the number of unique
10-mers in the genome. Following steps document how to install jellyfish from
source:

Get the source code directly by by preforming a wget on the source code link
which can be found on their git repo <a href="https://github.com/gmarcais/Jellyfish" here</a>.

```bash
wget https://github.com/gmarcais/Jellyfish/releases/download/v2.2.7/jellyfish-2.2.7.tar.gz
tar -xvf jellyfish-2.2.7.tar.gz
```

Once we have have the source file downloaded and uncompressed, we can run the
following commands to build jellyfish from source:

```bash
cd jellyfish-2.2.7
mkdir jellyfish
./configure --prefix=~/fsl_group/fslg_genome/bacteria-fingerprint/jellyfish-2.2.7/jellyfish
make
make install
```

These commands install all the jellyfish code from source and place the binary
files into a jellyfish directory. Now we just need to let the operating system
know where to find the correct files. We do this by adding the following lines
to the .bash_rc or .bash_profile file:

```bash
#jellyfish commands
export
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/fsl_group/fslg_genome/bacteria-fingerprint/jellyfish-2.2.7/jellyfish
alias jellyfish="~/fsl_group/fslg_genome/bacteria-fingerprint/jellyfish-2.2.7/jellyfish/bin/jellyfish"
```

Restart your connection with the supercomputer so that these commands can be
loaded. And now we can run jellyfish at the command simply by typing jellyfish.
Example:

```bash
jellyfish count -m 21 -s 100M -t 10 -C reads.fasta
```

User guide for the jellyfish software can be found <a href=http://www.genome.umd.edu/docs/JellyfishUserGuide.pdf> here</a>.
Jelly fish software is developed by Guillaume Marçais or Carl Kingsfor. 



