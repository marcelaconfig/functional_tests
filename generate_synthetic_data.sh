! /bin/bash

git clone git@github.com:GenomePathogenAnalysisService/gpas-covid-synthetic-reads.git

git clone https://github.com/oxfordmmm/gumpy
cd gumpy
pip install -r requirements.txt
python setup.py build --force
pip install .
cd ..

git clone https://github.com/cov-lineages/constellations.git

cd gpas-covid-synthetic-reads

pip install -r requirements.txt
pip install -e .

cd gpas-covid-synthetic-reads
for tech in illumina nanopore; do
    for primer in articv3 articv4 midnight1200; do
        for snps in {1..4}; do
            for coverage in {50..500..50}; do
                for error in {1..10..2}; do
                    for lineage in cB.1.1.7 cB.1.617.2 cB.1.1.529 cBA.1 cBA.2 cBA.3; do
                        python3 bin/gpas-covid-synreads-create.py\
                        --tech $tech\
                        --pango_definitions ../constellations/\
                        --variant_name $lineage\
                        --primers $primer\
                        --depth $coverage\
                        --snps $snps\
                        --error_rate $error\
                        --write_fasta
                    done;
                done;
            done;
        done;
    done;
    echo "Synthetic data generation is done for Illumina and Nanopore"
done;

ls *fastq | gzip *fastq
mkdir illumina nanopore
mv illumina-* illumina/
mv nanopore-* nanopore/



