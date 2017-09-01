package patch;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.Path;

/**
* Temporary hack because directory does not build
*/
public class Utils {
   public static boolean isReadableAndExists(String path){
        Path p = Paths.get(path);
        if(!Files.exists(p)) return false;        
        return Files.isReadable(p);
   }   
}
