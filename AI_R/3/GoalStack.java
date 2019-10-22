package goalstack;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Stack;




public class GoalStack {
	
	boolean onAB=false,onAC=false,onAD=false,onBC=false,onBA=false,onBD=false;
	boolean onDB=false,onDC=false,onDA=false,onCB=false,onCA=false,onCD=false;
	boolean clearA=false,clearB=false,clearC=false,clearD=false;
	boolean ontA=false,ontB=false,ontC=false,ontD=false;
	char hold = 'n';
	public boolean check(String p) {
		if(p.contains("ONT")){
			if(p.charAt(4)=='A')
				return ontA;
			else if (p.charAt(4)=='B')
				return ontB;
			else if (p.charAt(4)=='C')
				return ontC;
			else
				return ontD;
		}
		else if(p.contains("Clear")){
			if(p.charAt(6)=='A')
				return clearA;
			else if (p.charAt(6)=='B')
				return clearB;
			else if (p.charAt(6)=='C')
				return clearC;
			else
				return clearD;
		}else if(p.contains("HOLD")){
			if(hold==p.charAt(5)) {
				return true;
			}else {
				return false;
			}	
		}else if(p.contains("AE")) {
			if(hold=='n') {
				return true;
			}else {
				return false;
			}
		}else {
			if(p.equals("ON(A,B)"))
				return onAB;
			else if(p.equals("ON(A,C)"))
				return onAC;
			else if(p.equals("ON(A,D)"))
				return onAD;
			else if(p.equals("ON(B,A)"))
				return onBA;
			else if(p.equals("ON(B,C)"))
				return onBC;
			else if(p.equals("ON(B,D)"))
				return onBD;
			else if(p.equals("ON(C,B"))
				return onCB;
			else if(p.equals("ON(C,A)"))
				return onCA;
			else if(p.equals("ON(C,D)"))
				return onCD;
			else if(p.equals("ON(D,B)"))
				return onDB;
			else if(p.equals("ON(D,C)"))
				return onDC;
			else if(p.equals("ON(D,A)"))
				return onDA;
		}
		return false;
	}
	public void update(String s) {
		
		String predicate[]=s.split("\\^");
		//System.out.println("predicate"+ Arrays.toString(predicate));
		for(int i=0;i<predicate.length;i++) {
			if(predicate[i].contains("ONT")){
				//System.out.println(predicate[i]);
				if(predicate[i].charAt(4)=='A')
					ontA=true;
				else if (predicate[i].charAt(4)=='B')
					ontB=true;
				else if (predicate[i].charAt(4)=='C')
					ontC=true;
				else if (predicate[i].charAt(4)=='D')
					ontD=true;
			}
			else if(predicate[i].contains("ON")) {
				//System.out.println(predicate[i]);
				if(predicate[i].equals("ON(A,B)"))
					//System.out.print("yes");
					onAB=true;
				else if(predicate[i].equals("ON(A,C)"))
					onAC = true;
				else if(predicate[i].equals("ON(A,D)"))
					onAD = true;
				else if(predicate[i].equals("ON(B,A)"))
					onBA=true;
				else if(predicate[i].equals("ON(B,C)"))
					onBC = true;
				else if(predicate[i].equals("ON(B,D)"))
					onBD = true;
				else if(predicate[i].equals("ON(C,B)"))
					onCB=true;
				else if(predicate[i].equals("ON(C,A)"))
					onCA = true;
				else if(predicate[i].equals("ON(C,D)"))
					onCD = true;
				else if(predicate[i].equals("ON(D,B)"))
					onDB=true;
				else if(predicate[i].equals("ON(D,C)"))
					onDC = true;
				else if(predicate[i].equals("ON(D,A)"))
					onDA = true;
			}
			else if(predicate[i].contains("Clear")){
				if(predicate[i].charAt(6)=='A')
					clearA=true;
				else if (predicate[i].charAt(6)=='B')
					clearB=true;
				else if (predicate[i].charAt(6)=='C')
					clearC=true;
				else if (predicate[i].charAt(6)=='D')
					clearD=true;
			}
		}
	}
	public void setHold(char c) {
		hold = c;
	}
	public String precondUnstack(char a,char b) {
		return "ON(" + a +"," + b + ")^AE^Clear(" + a + ")";
	}
	public String precondStack(char a,char b) {
		return "HOLD(" + a + ")";
	}
	public String precondPickup(char a) {
		return "AE^ONT(" + a + ")^Clear(" + a + ")";
	}
	public String precondPutdown(char a) {
		return "HOLD(" + a + ")";
	}
	public void actionStack(char a,char b) {
		//return "ON(" + a +"," + b + ")^C(" + a + ")^AE";
		hold='n';
		setON(a,b);
		setC(a);
		clearC(b);
	}
	public void actionUnstack(char a,char b) {
		//return "HOLD(" + a + ")^C(" + b +")";
		setC(b);
		hold = a;
		clearON(a,b);
		//System.out.print("here in Unstack");
	}
	public void actionPutdown(char a) {
		//return "ONT(" + a + ")^C(" + a + ")^AE";
		hold = 'n';
		setONT(a);
		setC(a);
	}
	public void actionPickup(char a) {
		//return "HOLD(" + a + ")";
		hold = a;
		clearONT(a);
	}
	public void setC(char a) {
		switch(a) {
		case 'A':
			clearA=true;
			break;
		case 'B':
			clearB=true;
			break;
		case'C':
			clearC=true;
			break;
		case'D':
			clearD=true;
			break;
		}
	}
	public void clearC(char a) {
		switch(a) {
		case 'A':
			clearA=false;
			break;
		case 'B':
			clearB=false;
			break;
		case'C':
			clearC=false;
			break;
		case'D':
			clearD=false;
			break;
		}
	}
	public void setONT(char a) {
		switch(a) {
		case 'A':
			ontA=true;
			break;
		case 'B':
			ontB=true;
			break;
		case'C':
			ontC=true;
			break;
		case'D':
			ontD=true;
			break;
		}
	}
	public void clearONT(char a) {
		switch(a) {
		case 'A':
			ontA=false;
			break;
		case 'B':
			ontB=false;
			break;
		case'C':
			ontC=false;
			break;
		case'D':
			ontD=false;
			break;
		}
	}
	public void setON(char a,char b) {
		if(a=='A'&&b=='B') 
			onAB=true;
		else if(a=='A'&&b=='C')
			onAC=true;
		else if(a=='A'&&b=='D')
			onAD=true;
		else if(a=='B'&&b=='A')
			onBA=true;
		else if(a=='B'&&b=='C')
			onBC=true;
		else if(a=='B'&&b=='D')
			onBD=true;
		else if(a=='C'&&b=='A')
			onCA=true;
		else if(a=='C'&&b=='B')
			onCB=true;
		else if(a=='C'&&b=='D')
			onCD=true;
		else if(a=='D'&&b=='A')
			onDA=true;
		else if(a=='D'&&b=='B')
			onDB=true;
		else if(a=='D'&&b=='C')
			onDC=true;
	}
	public void clearON(char a,char b) {
		if(a=='A'&&b=='B') 
			onAB=false;
		else if(a=='A'&&b=='C')
			onAC=false;
		else if(a=='A'&&b=='D')
			onAD=false;
		else if(a=='B'&&b=='A')
			onBA=false;
		else if(a=='B'&&b=='C')
			onBC=false;
		else if(a=='B'&&b=='D')
			onBD=false;
		else if(a=='C'&&b=='A')
			onCA=false;
		else if(a=='C'&&b=='B')
			onCB=false;
		else if(a=='C'&&b=='D')
			onCD=false;
		else if(a=='D'&&b=='A')
			onDA=false;
		else if(a=='D'&&b=='B')
			onDB=false;
		else if(a=='D'&&b=='C')
			onDC=false;
	}
	
	

	@Override
	public String toString() {
		return "GoalStack [onAB=" + onAB + ", onAC=" + onAC + ", onAD=" + onAD + ", onBC=" + onBC + ", onBA=" + onBA
				+ ", onBD=" + onBD + ", onDB=" + onDB + ", onDC=" + onDC + ", onDA=" + onDA + ", onCB=" + onCB
				+ ", onCA=" + onCA + ", onCD=" + onCD + ", clearA=" + clearA + ", clearB=" + clearB + ", clearC="
				+ clearC + ", clearD=" + clearD + ", ontA=" + ontA + ", ontB=" + ontB + ", ontC=" + ontC + ", ontD="
				+ ontD + ", hold=" + hold + "]";
	}
	public static ArrayList<String> findTrue(GoalStack gs) throws IllegalArgumentException, IllegalAccessException {
		ArrayList<String> a = new ArrayList<String>();
		HashMap<String,Boolean> map = new HashMap<>();
		
		for (Field field : GoalStack.class.getDeclaredFields()) {
		    field.setAccessible(true);
		    if (field.getType().equals(boolean.class)){
		        map.put(field.getName(), (Boolean) field.get(gs));
		    } 
		}
		//System.out.println(map);
		map.forEach((key, value) -> {
		    if (value==true) {
		       a.add(key); 
		    }
		});
		
		
		return a;
	}
	public static void main(String[] args) throws IllegalArgumentException, IllegalAccessException {
		// TODO Auto-generated method stub
		GoalStack gs = new GoalStack();
		
		String initial = "ON(B,A)^ONT(C)^ONT(A)^ONT(D)^Clear(B)^Clear(C)^Clear(D)";
		String goal = "ON(C,A)^ON(B,D)";
		gs.update(initial);
		
		Stack<String> stack = new Stack<String>();
		ArrayList<String> steps = new ArrayList<>();
		stack.push(goal);
		while(!stack.empty()) {
		//for(int j =0;j<30;j++) {
			
			String curr = stack.peek();
			stack.pop();
			System.out.println("stack" + Arrays.toString(stack.toArray()));
			//if(curr.contains("Unstack") || curr.contains("Stack") ||curr.contains("Pickup")||curr.contains("Putdown")) {
				
				if(curr.contains("Unstack")){
					//System.out.println("here");
					gs.actionUnstack(curr.charAt(8),curr.charAt(10) );
					steps.add(curr);
				}else if(curr.contains("Stack")) {
					gs.actionStack(curr.charAt(6),curr.charAt(8) );
					steps.add(curr);
				}else if(curr.contains("Putdown")) {
					gs.actionPutdown(curr.charAt(8));
					steps.add(curr);
				}else if(curr.contains("Pickup")) {
					gs.actionPickup(curr.charAt(7));
					steps.add(curr);
				}
			else {
				String predicate[] = curr.split("\\^");
				if(predicate.length>1) {
					for(int i=0;i<predicate.length;i++) {
						//check if predicate is false
						//if(gs.check(predicate[i])==false) {
							//System.out.println("yup");
							stack.push(predicate[i]);
						//}
					}
				}else {
					if(gs.check(curr)==false) {
						//process the action and additional predicates.
						
						ArrayList<String> a = findTrue(gs);
						
						if(curr.contains("ONT")) {
							char ch='n';
							for(int i =0;i<a.size();i++) {
								if(a.get(i).contains("on")&& a.get(i).contains(curr.charAt(4)+"")) {
									ch = a.get(i).charAt(3);
									break;
								}
							}
							stack.push("Putdown("+curr.charAt(4)  +")");
							stack.push(gs.precondPutdown(curr.charAt(4)));
							stack.push("Unstack("+ curr.charAt(4) +","+ch+")");
							stack.push(gs.precondUnstack(curr.charAt(4),ch));
							
						}
						else if(curr.contains("ON")){
							stack.push("Stack(" +curr.charAt(3) +","+curr.charAt(5)+")");
							stack.push(gs.precondStack(curr.charAt(3), curr.charAt(5)));
						}
						else if(curr.contains("HOLD")) {
							stack.push("Pickup("+ curr.charAt(5)+")");
							stack.push(gs.precondPickup(curr.charAt(5)));
						}else if(curr.contains("AE")) {
							stack.push("Putdown(" + gs.hold +")");
							stack.push(gs.precondPutdown(gs.hold));
						}else {
							//find what to unstack from current
							char ch='n';
							for(int i =0;i<a.size();i++) {
								if(a.get(i).contains("on")&& a.get(i).contains(curr.charAt(6)+"")) {
									ch = a.get(i).charAt(2);
									break;
								}
							}
							stack.push("Unstack("+ ch +","+curr.charAt(6)+")");
							stack.push(gs.precondUnstack(ch,curr.charAt(6)));
						}
						
					}
					
				}
				
				
			}
				ArrayList<String> al = findTrue(gs);
				System.out.print(al);
				System.out.println("hold "+ gs.hold);
		}
		
		System.out.println("steps"+steps);
	}

}