#' pull GENCODE transcripts (default is v36 per GDC DR32)
#' 
#' @param v           GENCODE version; default (and, currently, only) is 36
#' @param whence      whence to retrieve it? ('data' or 'gs', GenomicState)
#' 
#' @return            a GRanges of GENCODE transcripts
#' 
#' @seealso           getGencodeTranscriptsByGene
#' @seealso           https://www.gencodegenes.org/human/
#'
#' @export
getGencodeTranscripts <- function(v=36, whence=c("data","gs")) { 

  whence <- match.arg(whence)

  if (whence == "data" && v == 36) { 

    # nb. these have HGNC symbols, unlike default TxDb schema 1.2
    name <- paste0("GENCODEv", v, "transcripts")
    data(list=c(name), package="bamSliceR")
    return(get(name))

  } else { 

    # turns out v36 and later are not in AnnotationHub... !
    stop("AnnotationHub has not been kept up to date... don't do this yet.")

    ah = AnnotationHub()
    aq <- subset(query(ah, c("TxDb", v, genome)), dataprovider=="GENCODE")
    if (length(aq) == 0) stop("No records found!")
    return(transcripts(ah[[aq$ah_id]], columns=c("tx_name","gene_id")))

  }

}
