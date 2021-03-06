#' A function to update R without losing packages, intended for Macs.
#'
#' @examples
#' \dontrun{
#' updateR()
#' }
#'
#' @export
updateR <- function() {
  cat("You need a working directory to save and load all your packages. \n\n")
  # 1 if yes, 2 if not
  useCur <- utils::menu(c("Yes", "No"), title = cat("Is this okay?\n", getwd(), "\n"))

  # Check if want to use current working directory, prompt for new if not.
  if (useCur == 1) {
    fp <- getwd()
  } else {
    fp <- readline("Enter the working directory to store or load your packages. Do not use quotes! \n")
  }
  # Change working directory.
  setwd(fp)

  # Check if they already have done Step 1: Saving the packages. Save if not.
  saved <- utils::menu(c("Yes", "No"), title = cat("Have you already saved your packages using this function?"))
  if (saved == 2) {
    tmp <- utils::installed.packages()
    installedpkgs <- as.vector(tmp[is.na(tmp[,"Priority"]), 1])
    npack <- length(installedpkgs)
    cat("You are now saving",npack,"packages to",getwd(),"\n")
    save(installedpkgs, file = "installed_old.rda")
    cat("Now close R, download the latest R version from www.r-project.org, then re-run this function. \n")
  } else if (saved == 1) {
    # Check that they have updated R, prompt to if not.
    updated <- utils::menu(c("Yes", "No"), title = cat("After saving, have you closed R and installed the newest version?"))
    if (updated == 2) {
      cat("If you are here, close R, then download the latest R version from www.r-project.org \n")
    } else if (updated == 1) {
      # Check that the current version is what they think, prompt to fix if not.
      cat("This is your current version: \n", R.Version()$version.string, "\n\n")
      checkUpdate <-  utils::menu(c("Yes", "No"), title = cat("Is this correct?"))
      if (checkUpdate ==  1) {
        load("installed_old.rda")
        npack <- length(installedpkgs)
        # Check you are loading what you think.
        checkPackages <-  utils::menu(c("Yes", "No"), title = cat("You have loaded",npack,"packages. Does this seem correct?"))
        if (checkPackages == 1) {
          tmp <- utils::installed.packages()
          installedpkgs.new <- as.vector(tmp[is.na(tmp[,"Priority"]), 1])
          missing <- setdiff(installedpkgs, installedpkgs.new)
          if (length(missing) != 0) {
            utils::install.packages(missing)
          }
          updatePackages <- utils::menu(c("Yes", "No"), title = cat("Packages installed. Would you like to update them?"))
          if (updatePackages == 1) {
            utils::update.packages(ask = FALSE)
          }
          cat("All done! \n")
        } else {
          cat("Make sure you are using the same filepath as when you saved your packages. Check and try again. \n")
        }
      } else {
        cat("Something went wrong and you are not using the updated version of R. Please redownload and try again. \n")
      }
    }
  }
}
