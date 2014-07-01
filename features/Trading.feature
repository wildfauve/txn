Feature: Performing Quota Assignment
  In order to assign quota
  An API Client 
  Should be able to provide quota assignment by an API
  
Scenario:

  Given I have a quota assignment
  When I provide an assignment trade
  Then the account should have a holding for the assignment
  