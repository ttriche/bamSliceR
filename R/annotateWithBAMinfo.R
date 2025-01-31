#' Annotate the variants with BAMs files information include: id, sample,
#' file_name, case_id, sample_type, experimental_strategy, workflow
#'
#' @param tallied_reads Either GRanges or VRanges contains reads tallying from BAM files
#' @param file_meta Data frame of info about each BAM files
#'
#' @return Either GRanges or VRanges 
#'
#' @import BiocParallel
#' @import VariantTools
#' @export
#'

annotateWithBAMinfo = function(tallied_reads, file_meta)
{
    bamfiles_names = str_c(file_meta$sample,  "_",
                           file_meta$case_id, "_",
                           file_meta$file_name)

    rownames(file_meta) = bamfiles_names
    
    mcols(tallied_reads) = cbind (mcols(tallied_reads),
                                  file_meta[as.character(sampleNames(tallied_reads)), ] )
    return(tallied_reads)
}
