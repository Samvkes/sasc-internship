version 1.0

workflow VariantCall {
    input {
        File input_bam
        String output_name
    }

    #call Prepare{} 

    #call BamSort {
        #input:
            #input_bam = input_bam,
    #}

    call Sniffles {
        input:
            sorted_bam = input_bam,
            output_name = output_name
    }

    output {
        File output_vcf = Sniffles.out
    }
}


task Prepare {
    command {
        conda activate ~/conda_venv/stage
    }
}


task BamSort {
    input {
        File input_bam
    }

    command {
        echo "Sorting is starting"
        samtools sort -o sorted.bam ${input_bam}
    }

    output {
        File out = "sorted.bam"
    }

}


task Sniffles {
    input {
        File sorted_bam
        String output_name
    }

    command {
        echo "Sniffles is starting"
        sniffles -m ${sorted_bam} -v ${output_name}.vcf
	echo "\n\nKlaar!\n\n"
    }

    output {
        File out = "${output_name}.vcf"
    }

}
