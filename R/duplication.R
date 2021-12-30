.vcat <- function(msg, verbose = TRUE) {
    if (verbose) {
        message(paste(msg, "\n"))
    }
}

.check_ids <- function(x) {
    if (is.null(x)) {
        return(0)
    }
    if (length(x) == 1) {
        if (is.na(x)) {
            return(0)
        }
    }
    return(length(x))
}

#' @rdname calculate_textsdc
#' @param ... parameters to be passed to `calculate_textsdc`
#' @export
calculate_duplication <- function(...) {
    calculate_textsdc(...)
}

#' Calculate duplication from a text vector
#'
#' This function uses the simple bag-of-words assumption to calculate possible duplicates in the input text vector. It works better with longer text than shorter text. `calculate_duplication` is provided for backward compatibility.
#'
#' @param input_text It can either be a text vector or a [quanteda::dfm()] object.
#' @param return_text_only logical, if TRUE, return only the cleaned version of text. If FALSE, return a duplication object.
#' @param method character, which method to calculate similarity between documents. Default is "cosine" (cosine similarity), other options are: "correlation", "jaccard", "ejaccard", "dice", "edice", "hammm", "simple matching", please refer to [quanteda.textstats::textstat_simil()]
#' @param threshold numeric, the numeric threshold of text similarity between two documents to be assumed to be a pair of duplicates. If percentile is TRUE, this threshold is a percentile rank.
#' @param percentile logical, if TRUE, threshold is a percentile rank. (i.e. two documents are assumed to be a pair of duplicates, when the text similarity between them is higher than this percentile.)
#' @param low_memory logical, if TRUE, the similarity matrix is not convert to a regular matrix. The trade-off: the deduplication process is going to be slower.
#' @param verbose logical, if TRUE, display debug messages.
#' @return a duplication object if return_text_only is FALSE. a text vector otherwise.
#' @export
calculate_textsdc <- function(input_text, return_text_only = FALSE, method = "cosine", threshold = 0.99, percentile = FALSE, low_memory = FALSE, verbose = FALSE) {
    if ("dfm" %in% class(input_text)) {
        res <- input_text
    } else {
        res <- quanteda::dfm(quanteda::tokens(input_text, what = "word"))
    }
    dist_matrix <- quanteda.textstats::textstat_simil(res, method = method, margin = "documents")
    if (percentile) {
        threshold <- as.numeric(stats::quantile(dist_matrix@x, probs = c(threshold)))
        .vcat(paste0("Threshold: ", threshold), verbose)
    }
    if (!low_memory) {
        dist_matrix <- as.matrix(dist_matrix)
    }
    excluded <- c()
    matching_ids <- list()
    bag <- c()
    for (i in 1:nrow(dist_matrix)) {
        if (!i %in% excluded) {
            clusters <- c(which(dist_matrix[i,] >= threshold))
            bag <- c(bag, i)
            if (length(clusters) > 1) {
                removing_ids <- setdiff(clusters, i)
                excluded <- c(excluded, removing_ids)
                matching_ids[[i]] <- as.numeric(clusters)
            } else {
                matching_ids[[i]] <- NA
            }
        }
    }
    if ("dfm" %in% class(input_text)) {
        clean_text <- input_text[bag,]
    } else {
        clean_text <- input_text[bag]
    }
    duplication <- list(input_text = input_text, clean_text = clean_text, bag = bag, excluded = excluded, matching_ids = matching_ids, method = method, threshold = threshold, dist_matrix = dist_matrix)
    class(duplication) <- append(class(duplication), "duplication")
    if (return_text_only) {
        return(clean_textsdc(duplication))
    }
    return(duplication)
}

#' Display duplication objects
#'
#' This method displays a preview of the input duplication object.
#'
#' @param x the duplication object to be displayed
#' @param ... not implemented
#' @return nothing
#' @export
print.duplication <- function(x, ...) {
    if ("dfm" %in% class(x$input_text)) {
        cat("DFM of", quanteda::ndoc(x$input_text), "document(s) with", length(x$excluded), "duplicates.\n")
    } else { 
        cat(paste("Text vector of length", length(x$input_text), "with", length(x$excluded), "duplicates.\n"))
    }
}

#' @rdname clean_textsdc
#' @param ... parameters to be passed to `clean_textsdc`
#' @export
get_deduplicated_version <- function(...) {
    clean_textsdc(...)
}

#' Extract deduplicated version from duplication objects
#'
#' This method extracts the deduplicated text vector of the input duplication object. `get_deduplicated_version` is provided for backward compatibility.
#'
#' @param duplication the duplication object to be processed
#' @param precedence character of one of the following options: earlier (default), longer, shorter, random. This option controls which document to take when duplicates exist. This is not used, when `input_text` is a dfm object.
#' \itemize{
#'    \item earlier: Take the document which is earlier in the input text vector.
#'    \item longer: Take the document which is longer.
#'    \item shorter: Take the document which is shorter.
#'    \item random: Randomly take a document.
#' }
#' @return a text vector or a dfm object
#' @export
clean_textsdc <- function(duplication, precedence = "earlier") {
    if ("dfm" %in% class(duplication$input_text)) {
        return(duplication$input_text[duplication$bag, ])
    }
    if (!precedence %in% c("earlier", "longer", "shorter", "random")) {
        stop("Please use a valid precedence option: earlier, longer, shorter, random")
    }
    if (precedence == "earlier") {
        return(duplication$clean_text)
    }
    bag <- which(is.na(duplication$matching_ids))
    excluded <- c()
    input_text_length <- nchar(duplication$input_text)
    ids_with_dups <- which(sapply(duplication$matching_ids, .check_ids) != 0)
    for (i in ids_with_dups) {
        cluster <- duplication$matching_ids[[i]]
        if (precedence == "longer") {
            target <- cluster[which.max(input_text_length[cluster])]
        } else if (precedence == "shorter") {
            target <- cluster[which.min(input_text_length[cluster])]
        } else if (precedence == "random") {
            target <- sample(cluster, 1)
        }
    
    removing_ids <- setdiff(cluster, target)
    excluded <- c(excluded, removing_ids)    
    bag <- sort(c(bag, target))
    }
    duplication$input_text[bag]
}
