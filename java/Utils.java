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
        if(!Files.isRegularFile(p)) return false; 
        System.out.println(path + " passed reg file check");       
        return Files.isReadable(p);
   } 

   public static long fileSize(String path) throws java.io.IOException{
        Path p = Paths.get(path);
        return Files.size(p);
   }    
}
