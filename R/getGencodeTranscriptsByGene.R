#' retrieve a GRangesList of GENCODE transcripts 
#' 
#' @param genes       a character vector of gene symbols
#' @param v           GENCODE version (default is 36)
#' @param ...         additional arguments to pass to getGencodeTranscripts
#'
#' @return            a GRangesList with one GRanges for each gene symbol
#' 
#' @seealso           getGencodeTranscripts
#'
#' @examples
#' 
#' # some of the following may become convenience functions in the future
#' genes <- c("RUNX1","H3C7","H3C10","H3-3A","H3-3B","IDH1","IDH2")
#' txs <- getGencodeTranscriptsByGene(genes)
#' si <- seqinfo(txs)
#'
#' # for variant tallying (used repeatedly below)
#' p <- PileupParam(min_mapq=13, include_insertions=TRUE)
#'
#' # for epigenomic scans (as with DNA methylation)
#' if (FALSE) subsetByOverlaps(SE, promoters(txs)))
#' 
#' # for genomic pileups, we need genomic coordinates
#' regions <- sort(unlist(GRangesList(sapply(txs, reduce))))
#' strand(regions) <- "*"
#' regions <- keepSeqlevels(regions, as.character(unique(seqnames(regions))))
#' gp <- ScanBamParam(which=regions, what=scanBamWhat())
#' 
#' # pileup by genomic region and add sensible names
#' if (FALSE) gpu <- pileup("genome.bam", scanBamParam=gp, pileupParam=p))
#' coordsToHGNC <- names(regions)
#' names(coordsToHGNC) <- as.character(regions)
#' if (FALSE) gpu$which_label <- coordsToHGNC[gpu$which_label]
#'
#' # for transcriptomic pileups, we need to convert genomic coords to contigs
#' ctgs <- unlist(txs, use.names=FALSE)
#' strand(ctgs) <- "*" 
#' ctgs <- shift(ctgs, -1 * (start(ctgs) - 1))
#' si2 <- Seqinfo(seqnames=names(ctgs), seqlengths=width(ctgs))
#' contigs <- GRanges(seqnames=names(ctgs), ranges=ranges(ctgs), seqinfo=si2)
#' names(contigs) <- ctgs$transcript_name
#'
#' # pileup by transcript and add sensible names
#' tp <- ScanBamParam(which=contigs, what=scanBamWhat())
#' if (FALSE) tpu <- pileup("transcriptome.bam", scanBamParam=tp, pileupParam=p)
#' contigToHGNC <- names(contigs)
#' names(contigToHGNC) <- as.character(contigs)
#' if (FALSE) tpu$which_label <- contigToHGNC[tpu$which_label]
#' 
#' @import            GenomicRanges
#'
#' @export
getGencodeTranscriptsByGene <- function(genes, v=36, ...) {

  txs <- subset(getGencodeTranscripts(v=v, ...), gene_name %in% genes)
  split(txs, txs$gene_name)

}
