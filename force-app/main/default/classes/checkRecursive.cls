public class checkRecursive {
    private static boolean run = true;
    public static boolean runOnce(){
        System.debug('Checking Recursive');
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
}