version 1.0

workflow Benchmark {
    input {
        File input_vcfList
        String output_name
    }

    call Prepare{} 

    call GenerateCombinations {
        input:
            input_vcfList = input_vcfList,
    }

    call Survivor {
        input:
            Array[File] combinations = GenerateCombinations.combinations,
            output_name = output_name
    }

    call PreProcess {
        input:
    }

    call Truvari {
        input:
    }

    call DrawUpset {
        input:
    }

    output {
        File output_image = DrawUpset.out
    }
}


task Prepare {
    command {
        conda activate /exports/sascstudent/samvank/conda2
    }
}


task GenerateCombinations {
    input {
        File input_vcfList
    }

    command {
        echo "Generating combinations"
        py GenerateCombinations.py
    }

    output {
        Array[File] combinations
    }

}


task Survivor {
    input {
        Array[File] combinations
    }

    command {
    }

    output {
    }

}


task PreProcess {
    input {
    }

    command {
    }

    output {
    }

}


task Truvari {
    input {
    }

    command {
    }

    output {
    }

}


task DrawUpset {
    input {
    }

    command {
    }

    output {
    }

}