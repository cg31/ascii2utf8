
import Data.Foldable
import qualified Data.ByteString as BS
import Control.Monad
import System.Directory
import System.Environment
import System.FilePath

--------------------------------------------------------------------------------

getFiles :: FilePath -> IO [FilePath]
getFiles dir = do
    names <- getDirectoryContents dir
    let properNames = filter (`notElem` [".", ".."]) names
    paths <- forM properNames $ \name -> do
        let path = dir </> name
        isDirectory <- doesDirectoryExist path
        if isDirectory then
            getFiles path
        else
            return [path]
    return (concat paths)

--------------------------------------------------------------------------------

doFile file = do
    let ext = takeExtension file
    if ext `elem` [".cpp", ".c"] then do
        putStrLn file
        putStrLn ext
    else
        return ()
    
doFile2 fileName = do
    let ext = takeExtension fileName
    when (ext `elem` [".htm", ".html", ".xhtml", ".xml"]) $ do
        putStrLn fileName
        --putStrLn ext
        fileData <- BS.readFile fileName
        let utf8BOM = BS.pack [0xEF, 0xBB, 0xBF]
        unless (utf8BOM `BS.isPrefixOf` fileData) $ do
            let newData = BS.concat [utf8BOM, fileData]
            BS.writeFile fileName newData
            print newData

--------------------------------------------------------------------------------

main = do
    
    curDir <- getCurrentDirectory
    files <- getFiles curDir
    {-
    print files

    putStrLn ""
    mapM_ (\item -> putStrLn item) files

    putStrLn ""
    forM_ files (\item -> putStrLn item)
    
    putStrLn ""
    traverse_ (\item -> putStrLn item) files

    putStrLn ""
    traverse_ doFile files

    putStrLn ""
    -}
    traverse_ doFile2 files
