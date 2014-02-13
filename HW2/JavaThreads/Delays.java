import java.io.*;
import java.lang.*;
import java.util.Vector;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

public class Delays implements Callable<int[]> {
    // static int[] dd = new int[4501];

    protected String filename;

    int[] delays = new int[4501];
    int min = -2250, max = 2250;

    public Delays(String name) {
	filename = name;
    }


    public int[] call() {
        java.io.InputStream fstream;
	try {
            
	    fstream = new java.io.FileInputStream(filename);
	    java.io.BufferedReader buf = new java.io.BufferedReader(new java.io.InputStreamReader(fstream));

	    buf.readLine(); // header

	    readRecords(buf);
            // showTable(); // show table
	    buf.close();
	} catch(Exception e) {
	    System.out.println("Problem processing " + filename);
	    System.out.println(e.toString());
	    e.printStackTrace();
	}
        //Thread.sleep(10000);
        return delays;
    }

    public void readRecords(BufferedReader buf) throws IOException {
	String line;
	int count = 0;
	while( (line = buf.readLine()) != null) {
	    String val = getDelay(line);
	    count ++;
	    storeDelay(val);
	}
	System.out.println("Number of lines processed for " + filename + " " + count);
    }

    public String getDelay(String line) {
	String[] els =  line.split(",");
	//	System.out.println(els[14]);
        if((int) Double.parseDouble(els[0]) >= 2008)
            return(els[44]);
        else
            return(els[14]);
    }

    protected void storeDelay(String value) {
	if(value != null && !value.isEmpty() && !value.equals("NA")) {  // not value != "NA" as in R!
	    int val = (int) Double.parseDouble(value);
	    if(val < min  || val > max)
		System.out.println("delay value problem " + val + ". Ignoring this value");
	    else{
		delays[val - min] ++;
            }
	}
    }

    public void showTable() {
	for(int i = 0; i < delays.length ; i++) {
	    if(delays[i] > 0)
		System.out.println( min + i + ": " + delays[i]);
	}
    }

    public static void main(String args[]) {
        try{
        int[] dd = new int[4501];
        List<Future<int[]>> resultList = new ArrayList<Future<int[]>>();

	if(args.length > 1) {
            ExecutorService pool = Executors.newFixedThreadPool(args.length);
	    int i;

	    for(i = 0; i < args.length; i++) {
                Delays ss = new Delays(args[i]);
                Future<int[]> result = pool.submit(ss);
                resultList.add(result);
	    }
            // Close pool
            for(Future<int[]> fut : resultList){
                 try {
                     int[] res = fut.get();
                     for(int k = 0; k < 4501; k++){
                         dd[k] += res[k];
                     }
            } catch (InterruptedException | ExecutionException e) {
                e.printStackTrace();
            }
            }
            pool.shutdown();
	} else {
	    Delays d = new Delays(args[0]);
            d.call();
            d.showTable();
	}
        
            FileWriter out = new FileWriter("delayData.txt");
            for(int i = 0; i < dd.length ; i++) {
	    if(dd[i] > 0){
		System.out.println( -2250 + i + ": " + dd[i]);
                    String str = Integer.toString(-2250 + i);
                    out.write(str+"\t");
                    String str1 = Integer.toString(dd[i]);
                    out.write(str1+"\n");
                }
            }
            out.close();
	}catch(IOException e){}
    }
}
