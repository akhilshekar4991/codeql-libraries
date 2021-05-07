import cpp
import semmle.code.cpp.dataflow.DataFlow

predicate searchforMulExpression(BlockStmt b3) {
	// Here the search begins for the Array and Multiplication expression
	exists(MulExpr expr | 
		expr.getEnclosingBlock() = b3)
	and	exists(ArrayExpr a |
		a.getEnclosingBlock() = b3)
}

predicate searchForsecondForStmt(BlockStmt b2, ForStmt f2) {
	exists(ForStmt f3 | 
		f3.getParent() = b2
	and	b2.getParentStmt() =f2
	and	searchforMulExpression(f3.getStmt()))
}

predicate searchForForStmt(BlockStmt b, ForStmt f) {
	exists(ForStmt i | 
		i.getParent() = b
	and	b.getParentStmt() =f
	and	searchForsecondForStmt(i.getStmt(), i))
}

from ForStmt forst, BlockStmt Body_1_stmt
where	forst.getStmt() = Body_1_stmt 

// Here the search begins for the 3-nested for loop statements
and	searchForForStmt(Body_1_stmt, forst)

select forst.getLocation(), "detected matrix multiplication", "you could use CBLAS library; sgemm()" 
