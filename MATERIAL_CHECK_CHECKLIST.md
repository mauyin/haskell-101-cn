# Weekly Course Material Verification Checklist

This checklist provides a standardized procedure for verifying the correctness and quality of each week's course materials.

---

## 📋 Pre-Check Setup

- [ ] Navigate to the week's directory
- [ ] Review README.md for objectives and structure
- [ ] Identify all files to check:
  - [ ] `lecture.md` - Main teaching content
  - [ ] `exercises.md` - Exercise descriptions
  - [ ] `tasks/*.hs` - Exercise template files
  - [ ] `solutions/*.hs` - Solution files

---

## 📚 Phase 1: Lecture Material Verification

### 1.1 Content Review
- [ ] Read through lecture.md
- [ ] Identify all code examples
- [ ] Note any special concepts or difficult topics
- [ ] Check for clarity of explanations

### 1.2 Code Example Testing
- [ ] Extract all code examples from lecture
- [ ] Create a test file with all examples
- [ ] Load in GHCi and verify compilation
- [ ] Test each example with sample inputs
- [ ] Verify outputs match documented expectations
- [ ] Document any errors or inconsistencies

### 1.3 Lecture Quality Assessment
- [ ] Are explanations clear?
- [ ] Are examples well-chosen?
- [ ] Is progression logical?
- [ ] Are there sufficient examples?
- [ ] Are Chinese translations accurate?

---

## 🎯 Phase 2: Exercise Verification

### 2.1 Exercise File Structure
- [ ] Check `tasks/*.hs` files exist
- [ ] Verify all functions have type signatures
- [ ] Check for helpful comments and hints
- [ ] Verify test functions are present
- [ ] Confirm files compile with `undefined` placeholders

### 2.2 Solution Verification
- [ ] Check `solutions/*.hs` files exist
- [ ] Load solutions in GHCi
- [ ] Verify solutions compile without errors
- [ ] Run built-in test suites (if present)
- [ ] Manually test edge cases
- [ ] Verify solutions follow good practices
- [ ] Check for alternative approaches

### 2.3 Exercise-Solution Consistency
- [ ] Compare type signatures (tasks vs solutions)
- [ ] Verify same function names
- [ ] Check same test cases
- [ ] Ensure solutions actually solve the exercises

---

## 🧪 Phase 3: Hands-On Learning Verification

### 3.1 Complete Exercises as Learner
For each section:
- [ ] Read exercise description
- [ ] Implement solution independently
- [ ] Test with GHCi
- [ ] Run automated tests
- [ ] Compare with provided solution
- [ ] Document any difficulties encountered

### 3.2 Exercise Categories
Track completion for each category:
- [ ] Section 1: [Name] (X/Y completed)
- [ ] Section 2: [Name] (X/Y completed)
- [ ] Section 3: [Name] (X/Y completed)
- [ ] Section 4: [Name] (X/Y completed)
- [ ] Section 5: [Name] (X/Y completed)
- [ ] Challenge Problems (if applicable)

---

## ✅ Phase 4: Testing & Validation

### 4.1 Automated Tests
- [ ] Run all provided test functions
- [ ] Document pass/fail rates
- [ ] Investigate any failures
- [ ] Verify test coverage is adequate

### 4.2 Manual Testing
- [ ] Test with edge cases (empty lists, zeros, negatives)
- [ ] Test with invalid inputs (if applicable)
- [ ] Test with large inputs (performance check)
- [ ] Verify error messages are helpful

### 4.3 Cross-Reference Check
- [ ] Exercises match lecture concepts
- [ ] Difficulty progression is appropriate
- [ ] Prerequisites are covered
- [ ] Hints are sufficient but not too revealing

---

## 📝 Phase 5: Documentation & Reporting

### 5.1 Issues Found
Document any issues in categories:

**Critical Issues** (prevent learning):
- [ ] Code that doesn't compile
- [ ] Incorrect solutions
- [ ] Missing essential files
- [ ] Misleading instructions

**Medium Issues** (cause confusion):
- [ ] Unclear explanations
- [ ] Insufficient examples
- [ ] Inconsistent terminology
- [ ] Missing edge cases

**Minor Issues** (polish needed):
- [ ] Typos or grammar errors
- [ ] Formatting inconsistencies
- [ ] Outdated references
- [ ] Minor warnings

### 5.2 Quality Metrics
Rate on scale of 1-5:
- [ ] **Correctness**: All code works as documented
- [ ] **Completeness**: Covers all stated objectives
- [ ] **Clarity**: Explanations are easy to understand
- [ ] **Difficulty**: Appropriate for the week
- [ ] **Examples**: Sufficient and well-chosen

### 5.3 Create Summary Report
Include in `WEEK_X_CHECK_REPORT.md`:
- [ ] Completion status
- [ ] Test results summary
- [ ] List of issues found
- [ ] Quality assessment
- [ ] Recommendations for improvement
- [ ] Learner experience notes

---

## 🎓 Phase 6: Final Assessment

### 6.1 Learning Objectives
- [ ] Can learner achieve stated objectives?
- [ ] Is prerequisite knowledge sufficient?
- [ ] Does week prepare for next week?
- [ ] Are exercises well-balanced?

### 6.2 Readiness Check
- [ ] Material is ready for learners: YES / NO / NEEDS WORK
- [ ] Solutions are verified correct: YES / NO
- [ ] Tests are comprehensive: YES / NO
- [ ] Documentation is clear: YES / NO

### 6.3 Sign-Off
- [ ] All phases completed
- [ ] Report generated
- [ ] Issues documented
- [ ] Ready for next week (if applicable)

---

## 📊 Quick Reference Summary

| Phase | Focus | Key Outputs |
|-------|-------|-------------|
| 1 | Lecture Content | Verified examples, quality notes |
| 2 | Exercise Files | Solution verification, consistency check |
| 3 | Hands-On Learning | Completed exercises, learner experience |
| 4 | Testing | Test results, edge cases |
| 5 | Documentation | Issue list, quality metrics |
| 6 | Final Assessment | Readiness determination, sign-off |

---

## 🔄 Continuous Improvement

After each week's check:
- [ ] Update checklist based on new insights
- [ ] Refine testing procedures
- [ ] Add new categories if needed
- [ ] Share learnings with team

---

**Version**: 1.0
**Last Updated**: 2025-01-18
**Maintained By**: Course Quality Team

