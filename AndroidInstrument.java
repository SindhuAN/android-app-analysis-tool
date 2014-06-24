
import java.util.Iterator;
import java.util.Map;
import java.lang.System;
import soot.jimple.*;
import soot.tagkit.*;

import soot.util.*;
import soot.options.Options;
import soot.Body;
import soot.BodyTransformer;
import soot.Local;
import soot.PackManager;
import soot.PatchingChain;
import soot.RefType;
import soot.Scene;
import soot.SootClass;
import soot.SootMethod;
import soot.Transform;
import soot.Unit;
import soot.jimple.StringConstant;
import soot.jimple.internal.JInvokeStmt;
import soot.jimple.internal.JStaticInvokeExpr;
import soot.jimple.internal.JVirtualInvokeExpr;
import soot.BooleanType;
import soot.ByteType;
import soot.LongType;
import soot.Value;
import soot.Type;
import soot.*;



import java.io.*;
import java.util.*;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;



//DEVICE ID by dialing  *#*#8255#*#*
//device-id: 3d09ecbecb731f6fd56


public class AndroidInstrument {
//	static SootClass loadClassInstrCode;// = Scene.v().loadClassAndSupport("java.io.PrintStream");
	

	public static void main(String[] args) {

		

		
		
		//prefer Android APK files// -src-prec apk
		Options.v().set_src_prec(Options.src_prec_apk);
		
		System.out.println("Test continues");
		//output as APK, too//-f J
		Options.v().set_output_format(Options.output_format_dex);
		
        // resolve the PrintStream and System soot-classes
		Scene.v().addBasicClass("java.io.PrintStream",SootClass.SIGNATURES);
        Scene.v().addBasicClass("java.lang.System",SootClass.SIGNATURES);
		Scene.v().addBasicClass("java.io.File",SootClass.SIGNATURES);
		Scene.v().addBasicClass("java.io.FileOutputStream",SootClass.SIGNATURES);
		Scene.v().addBasicClass("java.lang.Boolean",SootClass.SIGNATURES);
		Scene.v().addBasicClass("android.os.Environment",SootClass.SIGNATURES);
		//Scene.v().addBasicClass("comcom.example.hello.InstrCode",SootClass.SIGNATURES);
		Scene.v().addBasicClass("android.content.Context",SootClass.SIGNATURES);
		
		
		PackManager.v().getPack("jtp").add(new Transform("jtp.instrumenter", GotoInstrumenter.v()));
     	soot.Main.main(args);
	}
}


class GotoInstrumenter extends BodyTransformer
{
//InstrCode
	static SootClass loadClassInstrCode;
	static SootMethod methodSootCall;
	public static String packagePath;
	
	//static SootMethod methodSootCall; = loadClassInstrCode.getMethod("FileWriteTest");
	
	
	//reportCounter = counterClass.getMethod("void report(java.lang.String,java.lang.String,java.lang.String)");
	
    private static GotoInstrumenter instance = new GotoInstrumenter();
    private GotoInstrumenter() 
	{
	}

    public static GotoInstrumenter v() { 
/*read here the package.txt*/
		System.out.println("Reading file");
		String fileName="package.txt";
		readFile(fileName);
		System.out.println("Finishing reading file");
		/*end of read*/
return instance; 

}
	
	// private boolean addedFieldToMainClassAndLoadedPrintStream = false;
     //private SootClass javaIoPrintStream;
	 //android.content.Context
	 //java.io.FileOutputStream
	 
	  	private Local addTmpFileOutPut(Body body)
    {															//java.io.PrintStream
       Local tmpRef = Jimple.v().newLocal("tmpContextFileOutput",RefType.v("java.io.FileOutputStream"));
	   //Local tmpRef = Jimple.v().newLocal("tmpRef", RefType.v("InstrCode"));
        body.getLocals().add(tmpRef);
        return tmpRef;
    }
	 
	 	private Local addTmpContext(Body body)
    {															//java.io.PrintStream
       Local tmpRef = Jimple.v().newLocal("tmpContext",RefType.v("android.content.Context"));
	   //Local tmpRef = Jimple.v().newLocal("tmpRef", RefType.v("InstrCode"));
        body.getLocals().add(tmpRef);
        return tmpRef;
    }
	 
	  	private Local addTmpBoolean1(Body body)
    {															//java.io.PrintStream
       Local tmpRef = Jimple.v().newLocal("tmpRefBoolean",BooleanType.v());
	   //Local tmpRef = Jimple.v().newLocal("tmpRef", RefType.v("InstrCode"));
        body.getLocals().add(tmpRef);
        return tmpRef;
    }
	 
	 	private Local addTmpBoolean(Body body)
    {															//java.io.PrintStream
       Local tmpRef = Jimple.v().newLocal("tmpRefBoolean",BooleanType.v());
	   //Local tmpRef = Jimple.v().newLocal("tmpRef", RefType.v("InstrCode"));
        body.getLocals().add(tmpRef);
        return tmpRef;
    }
	  

	private Local addTmpRef(Body body)
    {															//java.io.PrintStream
       Local tmpRef = Jimple.v().newLocal("tmpRef", RefType.v("java.io.PrintStream"));
	   //Local tmpRef = Jimple.v().newLocal("tmpRef", RefType.v("InstrCode"));
        body.getLocals().add(tmpRef);
        return tmpRef;
    }
	
	private Local addTmpRefEnv(Body body)
	{
	//android.os.Environment
		Local tmpRef = Jimple.v().newLocal("tmpRefEnv", RefType.v("android.os.Environment"));
	   //Local tmpRef = Jimple.v().newLocal("tmpRef", RefType.v("InstrCode"));
        body.getLocals().add(tmpRef);
        return tmpRef;
	
	}
	
	private Local addTmpRef2(Body body)
    {															//java.io.PrintStream
       
	   Local tmpRef = Jimple.v().newLocal("tmpRef", RefType.v("comcom.example.hello.InstrCode"));
        body.getLocals().add(tmpRef);
        return tmpRef;
    }
     
	private Local addTmpByteArray(Body body)
    {
        Local tmpLong = Jimple.v().newLocal("tmpByteArray", ArrayType.v(ByteType.v(),100)); 
        body.getLocals().add(tmpLong);
        return tmpLong;
    } 
	 
	private Local addTmpByte(Body body)
    {
        Local tmpLong = Jimple.v().newLocal("tmpByte", ByteType.v()); 
        body.getLocals().add(tmpLong);
        return tmpLong;
    } 
	 
    private Local addTmpLong(Body body)
    {
        Local tmpLong = Jimple.v().newLocal("tmpLong", LongType.v()); 
        body.getLocals().add(tmpLong);
        return tmpLong;
    }
	
		private Local addTmpLocalStr(Body body)
    {
        Local tmpString = Jimple.v().newLocal("tmpStringStr1", RefType.v("java.lang.String")); 
        body.getLocals().add(tmpString);
        return tmpString;
    }
	
	
	private Local addTmpStringDir(Body body)
    {
        Local tmpString = Jimple.v().newLocal("tmpStringDir", RefType.v("java.lang.String")); 
        body.getLocals().add(tmpString);
        return tmpString;
    }
	
	private Local addTmpString(Body body)
    {
        Local tmpString = Jimple.v().newLocal("tmpString", RefType.v("java.lang.String")); 
        body.getLocals().add(tmpString);
        return tmpString;
    }
	
	private Local addTmpStringPath(Body body)
    {
        Local tmpString = Jimple.v().newLocal("tmpStringPath", RefType.v("java.lang.String")); 
        body.getLocals().add(tmpString);
        return tmpString;
    }
	
	private Local addTmpFile6(Body body)
    {
        Local tmpString = Jimple.v().newLocal("tmpFile6", RefType.v("java.io.FileOutputStream")); 
        body.getLocals().add(tmpString);
        return tmpString;
    }
	
	private Local addTmpFile5(Body body)
    {
        Local tmpString = Jimple.v().newLocal("tmpFile5", RefType.v("java.io.FileOutputStream")); 
        body.getLocals().add(tmpString);
        return tmpString;
    }
	
	private Local addTmpFile(Body body)
    {
        Local tmpString = Jimple.v().newLocal("tmpFile", RefType.v("java.io.File")); 
        body.getLocals().add(tmpString);
        return tmpString;
    }
	private Local addTmpFile1(Body body)
    {
        Local tmpString = Jimple.v().newLocal("tmpFile1", RefType.v("java.io.File")); 
        body.getLocals().add(tmpString);
        return tmpString;
    }
	
	private Local addTmpFile2(Body body)
    {
        Local tmpString = Jimple.v().newLocal("tmpFile2", RefType.v("java.io.File")); 
        body.getLocals().add(tmpString);
        return tmpString;
    }
	
	
	private void handleClass(SootClass sclass)
	{
	
	
	}
	
	private void handleMethod( SootMethod m)
	{ 
	
	}
	
	private void createFileStatic(String signature)
	{
		final String FILE_NAME = "static-analysis.txt";
		
		
		byte b [] = signature.getBytes();// hello.getBytes(); 
		
		
		  try {
			File file = new File( FILE_NAME);
		 	OutputStream os;
			os = new FileOutputStream(file,true);
				try {
					os.write(b);
				}
				catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
			
				}
			os.flush();
			os.close();
			
		}			  
		catch (Exception e) {
				   //Log.i("ReadNWrite, fileCreate()", "Exception e = " + e);
				   System.out.println("Read test creationg problem\n"+"Exception e = " +e);
				   
			}
				
		
			 
		 
	
	}

	/*reading file*/
	
	//public String

	/*read here the package.txt*/
		/*System.out.println("Reading file");
		String fileName="package.txt";
		readFile(fileName);
		System.out.println("Finishing reading file");*/
		/*end of read*/


	public static String readFile(String filename)
	{
		String content = null;
		File file = new File(filename); //for ex foo.txt
		try {
			FileReader reader = new FileReader(file);
			char[] chars = new char[(int) file.length()-1];
			reader.read(chars);
			content = new String(chars);
			reader.close();
		}
		catch (IOException e) {
			e.printStackTrace();
		}
		System.out.println(content);
		packagePath=content;
		return content;
	}
	
	
	protected void internalTransform(Body body, String phaseName, Map options)
    {
		int tmp;
		Value argValue;
		Type argType;
		String methodArgs;
		String argValueString;
        
		//get all the statements
		 Chain units = body.getUnits();
		 
		 //get all the local variables 
		 Chain locals = body.getLocals();
		 
		// SootMethod method = body.getMethod();
		 	     
            
                
                          
            Iterator stmtIt = units.snapshotIterator();
			
		            
            while(stmtIt.hasNext())
            {
			  
                Stmt s = (Stmt) stmtIt.next();
				
								
				if(s.containsInvokeExpr()==true){
				
					Local tmpBooleanObj = addTmpBoolean1(body);
					SootClass BooleanClassJava = Scene.v().getSootClass("java.lang.Boolean");
					SootMethod BooleanClassMethod = BooleanClassJava.getMethod("void <init>(java.lang.String)");
					SootMethod toCallBoolean = Scene.v().getSootClass("java.lang.Boolean").getMethod("boolean getBoolean(java.lang.String)");
					SootMethod toCallBooleanValue = Scene.v().getSootClass("java.lang.Boolean").getMethod("boolean booleanValue()");
					
					Stmt tmpBooleanObjStmt = Jimple.v().newAssignStmt(tmpBooleanObj, Jimple.v().newNewExpr(BooleanClassJava.getType()));
					units.insertBefore(tmpBooleanObjStmt,s);
					//getInvokeExpr
					//InvokeExpr getInvokeExpr()
						
					////booleanValue() 			
					
					/////////////////
		
					
					Local tmpBooleanString = addTmpLocalStr(body);
					AssignStmt assignStmtStringTrue = Jimple.v().newAssignStmt(tmpBooleanString,StringConstant.v("true"));
					units.insertBefore(assignStmtStringTrue,s);
					
					Stmt initobjectBoolean = Jimple.v().newInvokeStmt(Jimple.v().newSpecialInvokeExpr(tmpBooleanObj,BooleanClassMethod.makeRef(),tmpBooleanString));
					units.insertBefore(initobjectBoolean,s);
					
					InvokeExpr invBooleanValue = Jimple.v().newVirtualInvokeExpr(tmpBooleanObj,toCallBooleanValue.makeRef());
					Local tmpBoolean = addTmpBoolean(body);
					AssignStmt assignStmtBooleanValue = Jimple.v().newAssignStmt(tmpBoolean,invBooleanValue);
					units.insertBefore(assignStmtBooleanValue,s);
					
						  		
					InvokeExpr iexpr = s.getInvokeExpr();
					
					int numArgs = iexpr.getArgCount();
					String numStringArgs = String.valueOf(numArgs);
					methodArgs="";
					argValueString="";
					for(tmp=0;tmp<numArgs;tmp++){
						argValue=iexpr.getArg(tmp);
						argType =argValue.getType();
						methodArgs+=argType.toString();
						methodArgs+=" ";
						argValueString+=argValue;
						argValueString+=" ";
						if(argType.toString().equals("java.lang.String")){
								//argValueString+=argValue;
						}
					}
					
						
					//String s_method = new String(iexpr.getMethod().getName());
					String s_signat = new String(iexpr.getMethod().getSignature());
					
					System.out.println(s_signat);
					createFileStatic(s_signat+"\n");
					
						
					Local tmpStringSignature = addTmpString(body); 
					//This will be removed and replaced by signature only
					//AssignStmt assignStmtSignature = Jimple.v().newAssignStmt(tmpStringSignature,StringConstant.v(s_signat+":"+numStringArgs+":"+methodArgs+":"+argValueString+"\n"));
					AssignStmt assignStmtSignature = Jimple.v().newAssignStmt(tmpStringSignature,StringConstant.v(s_signat+"\n"));//+":"+numStringArgs+":"+methodArgs+":"+argValueString+"\n"));
					units.insertBefore(assignStmtSignature, s);
					//////////////////
					
								
					
					 					
					
					SootClass fileClassOutjava = Scene.v().getSootClass("java.io.FileOutputStream");
					//SootMethod toCallFileOut = fileClassOutjava.getMethod("void <init>(java.io.File)");//,boolean)");
					//SootMethod toCallFileOut = fileClassOutjava.getMethod("void <init>(java.lang.String)");//,boolean)");
					SootMethod toCallFileOut = fileClassOutjava.getMethod("void <init>(java.lang.String,boolean)");//,boolean)");
					Local tmpFile5 = addTmpFile5(body);
					Stmt newstmtFileOutputStream = Jimple.v().newAssignStmt(tmpFile5, Jimple.v().newNewExpr(fileClassOutjava.getType()));
					units.insertBefore(newstmtFileOutputStream,s);
					
					
					
					//StringConstant.v("log-out")
					//Stmt initFileOut = Jimple.v().newInvokeStmt(Jimple.v().newSpecialInvokeExpr(tmpFile5,toCallFileOut.makeRef(),margsOutputStream));
					
					List MargsOutTmp = new ArrayList();
					//com.rerware.android.MyBookmarks
					//com.stoik.mdscanlite
					//com.globaldroid.fbtouch
					//tip.calculator
					//com.vladyud.balance (Balance)
					//com.patrickintw.TravelDiary/
					//com.rerware.android.MyBookmarks
					//com.incorporateapps.teleport com.incorporateapps.teleport-1
					//ru.grocerylist.android/
					//BalanceBY.apk
					//com.asyn.bazinga
					///data/data/com.t2.t2expense
					//data/data/com.EnglishGrammarExercises
					//dk.thomasen.android
					///data/data/tip.calculator
					//org.itsbsmaihoefer.einkaufszettel
					//org.openintents.shopping
					///home/oper/Dropbox/GoogleKeep.apk
					//com.google.android.keep

					//packagePath
					//MargsOutTmp.add(StringConstant.v("/data/data/com.example.hello/log-out"));
					MargsOutTmp.add(StringConstant.v("/data/data/"+packagePath+"/log-out"));
					MargsOutTmp.add(tmpBoolean);
					
					Stmt initFileOut = Jimple.v().newInvokeStmt(Jimple.v().newSpecialInvokeExpr(tmpFile5,toCallFileOut.makeRef(),MargsOutTmp));
					
					units.insertBefore(initFileOut,s);
					
					SootMethod swrite = Scene.v().getSootClass("java.io.OutputStream").getMethod("void write(byte[])"); 
					SootClass stringclass = Scene.v().getSootClass("java.lang.String");
					SootMethod stringMethodgetBytes = stringclass.getMethod("byte[] getBytes()");
													
					Local tmpByteArray= addTmpByteArray(body);
					InvokeExpr invExprStringGetBytes = Jimple.v().newVirtualInvokeExpr(tmpStringSignature,stringMethodgetBytes.makeRef());
					AssignStmt assignStmtStringGetBytes = Jimple.v().newAssignStmt(tmpByteArray,invExprStringGetBytes);
					units.insertBefore(assignStmtStringGetBytes,s);
					
					Stmt stmtInvWrite = Jimple.v().newInvokeStmt(Jimple.v().newVirtualInvokeExpr(tmpFile5,swrite.makeRef(),tmpByteArray));
					units.insertBefore(stmtInvWrite,s);
					
					//close the output
					SootMethod sclose = Scene.v().getSootClass("java.io.OutputStream").getMethod("void close()"); 
					Stmt stmtInvClose = Jimple.v().newInvokeStmt(Jimple.v().newVirtualInvokeExpr(tmpFile5,sclose.makeRef()));
					units.insertBefore(stmtInvClose,s);
					
					//body.validate();  							  
					
					}
			}
        }
}
