#' Atom coordinates to data frame
#'
#' Create a data frame with the cordinates of the selected atoms. It is based on bio3d functions. 
#' @param pdb Structure object of class pdb as read by read.pdb() funcion of bio3d lib.
#' @param trj (Optional) trajectory as read by read.dcd() funcion of bio3d lib.
#' @param sel_string Selection of atom for bio3d function atom.select(), refer to manual (es. "///71///CD/")
#' @keywords coordinates 
#' @export
#' @examples
#' pot.pdb <- read.pdb(pot.pdbfile)
#' pot.trj <- read.dcd(pot.dcdfile)
#' K80 <- "///80///K/"
#' coord.data.frame (pot.pdb, pot.trj, K80)

coord.data.frame.R <- function( pdb, trj=NULL, sel_string) {
  ## return a matrix with the xyz coords from the of the atoms
  ## selected using sel_string, from trj, using pdb as reference
  ## using bio3d http://users.mccammon.ucsd.edu/~bgrant/bio3d/index.html
  require(bio3d)

  ## create a selection 
  selection <- atom.select(pdb, sel_string)

  ## define n of atoms that have been selected
  natom <- length(selection[["atom"]])

  ## read the indeces to read from the pdb (and optionally dcd) objects
  atom.type.idx <- selection[["atom"]]
  sel.idx <- selection[["xyz"]]

  ## creating names for the data.frame
  if (natom == 1) {
    atom.type <- paste(pdb[["atom"]][,c("segid","resno","elety")][atom.type.idx,], collapse=" ")
  } else if (natom > 1) {
    atom.type <- apply(
      pdb[["atom"]][,c("segid","resno","elety")][atom.type.idx,],1, paste, collapse=" "
      )
  } else {
    stop( "atom.select2data.frame: error, wrong selection")
  }


  ## creating the data.frame
  if (!is.null(trj)) {
    sel.trj <- trj[,sel.idx]
  } else {
    sel.trj <- as.data.frame(t(pdb[["xyz"]][sel.idx]))
  }
  ## naming the columns
  colnames(sel.trj) <- paste(rep(atom.type, each=3),c("x","y","z"))
  return(sel.trj)
}
