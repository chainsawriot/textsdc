.vcat <- function(msg, verbose = TRUE) {
    if (verbose) {
        cat(paste(msg, "\n"))
    }
}

#' Calculate duplication from a text vector
#'
#' This function uses the simple bag-of-words assumption to calculate possible duplicates in the input text vector. It works better with longer text than shorter text.
#'
#' @param input_text text vector to be analysed
#' @param return_text_only logical, if TRUE, return only the cleaned version of text. If FALSE, return a duplication object.
#' @param method character, which method to calculate similarity between documents. Default is "cosine" (cosine similarity), other options are: "correlation", "jaccard", "ejaccard", "dice", "edice", "hammm", "simple matching", please refer to quanteda::textstat_simil()
#' @param threshold numeric, the numeric threshold of text similarity between two documents to be assumed to be duplicates. If percentile is TRUE, this threshold is a percentile rank.
#' @param percentile logical, if TRUE, threshold is a percentile rank. (i.e. two documents are assumed to be duplicates, when the text similarity between them is higher than this percentile.)
#' @param low_memory logical, if TRUE, the similarity matrix is not convert to matrix. The trade-off: the deduplication process is going to be slower.
#' @param verbose logical, if TRUE, display debug messages.
#' @return a duplication object if return_text_only is FALSE. a text vector otherwise.
#' @export
calculate_duplication <- function(input_text, return_text_only = FALSE, method = "cosine", threshold = 0.99, percentile = FALSE, low_memory = FALSE, verbose = FALSE) {
    res <- quanteda::dfm(input_text)
    dist_matrix <- quanteda::textstat_simil(res, method = method, margin = "documents")
    if (percentile) {
        threshold <- as.numeric(quantile(dist_matrix@x, probs = c(threshold)))
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
                matching_ids[[i]] <- removing_ids
            }
        }
    }
    duplication <- list(input_text = input_text, clean_text = input_text[bag], bag = bag, excluded = excluded, matching_ids = matching_ids, method = method, threshold = threshold, dist_matrix = dist_matrix)
    class(duplication) <- append(class(duplication), "duplication")
    if (return_text_only) {
        return(get_deplicated_version(duplication))
    }
    return(duplication)
}

#' Display duplication objects
#'
#' This method displays a preview of the input duplication object.
#'
#' @param duplication the duplication object to be displayed
#' @return nothing
#' @export
print.duplication <- function(duplication) {
    cat(paste("Text vector of length", length(duplication$input_text), "with", length(duplication$excluded), "duplicates.\n"))
}

#' Extract deduplicated version from duplication objects
#'
#' This method extracts the deduplicated text vector of the input duplication object.
#'
#' @param duplication the duplication object to be processed
#' @return a text vector
#' @export
get_deduplicated_version <- function(duplication) {
    duplication$clean_text
}
