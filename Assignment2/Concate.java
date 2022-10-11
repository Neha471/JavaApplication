import java.io.*;
import java.util.*;
class Solution {
	private void recurPermute(int index, String[] nums, List < List < String >> ans) {
		if (index == nums.length) {
		// copy the ds to ans
			List < String > ds = new ArrayList < > ();
			for (int i = 0; i < nums.length; i++) {
				ds.add(nums[i]);
			}
			ans.add(new ArrayList < > (ds));
			return;
 		}						                                                                                       
		for (int i = index; i < nums.length; i++){
			swap(i, index, nums); 
			recurPermute(index + 1, nums, ans);
			swap(i, index, nums); 
		}
	}
	private void swap(int i, int j, String[] nums) {
		String t = nums[i];
		nums[i] = nums[j];
		nums[j] = t;
						
	}

	public List < List < String >> permute(String[] nums) {
		List < List < String >> ans = new ArrayList < > ();
		recurPermute(0, nums, ans);
		return ans;
	}
};
						
class Concate {
					
	public static void main(String[] args) {
		String nums[] = {"ab","cd","ef"};
		Solution sol = new Solution();
		List < List < String >> ls = sol.permute(nums);			
		System.out.println("All Permutations are");
		for (int i = 0; i < ls.size(); i++) {
			for (int j = 0; j < ls.get(i).size(); j++) {
				System.out.print(ls.get(i).get(j) + "");
			}
			System.out.println();
						
		}
						
	}
						
}
