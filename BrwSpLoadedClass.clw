
! overloaded functions

  member
  
  map
  end

  include('BrwSpLoadedClass.inc'),once

!  -------------------------------------------------------------------------------
! fetch method
! calls the parent fetch and then closes the view.  
! the close is needed or the driver will throw the statement busy error 
! when the update form is called. 
!  -------------------------------------------------------------------------------
brwSpLoadedClass.fetch procedure(BYTE Direction)

  code 

  parent.fetch(direction)
  self.close()
  
  return
! ---------------------------------------------------------

!  -------------------------------------------------------------------------------
! reset method
! check the queue for rows, if none then open the view and call the stored procedure.
! the view is closed after the read. 
! since this is a file loaded browse once the queue is loaded we do not need to load it 
! again so just return.
! 
! this is an example and in actual use this code would be in the embed point for 
! the procedure, or you can hard code the sp name here, add a string property 
! to the derived class and set it there along with any parameters and 
! parameter values.
!  -------------------------------------------------------------------------------
brwSpLoadedClass.reset procedure() !virtual

  code
  
  if (self.listQueue.records() <= 0)
    self.open()
    self.view{prop:sql} = 'call dbo.readProducts'
  end
  
  return
! -------------------------------------------------------------

! ----------------------------------------------------------------
! these are for the update form calls, not yet fully implemented.
! but will be soon(tm).
! ----------------------------------------------------------------
   
brwSpLoadedClass.resetFromFile procedure()

  code

  self.listQueue.fetch(self.ilc.choice()) 
  self.fields.assignLeftToRight()
  self.listqueue.update()
  
  return
! ------------------------------------------------------------

brwSpLoadedClass.resetQueue procedure(byte resetMode) !virtual

  code
 
  if (self.listQueue.Records() <= 0)
    parent.resetQueue(resetMode)
  end
 
  return
! ------------------------------------------------------------   

brwSpLoadedClass.updateViewRecord procedure()

  code 
  
  SELF.CurrentChoice = SELF.ILC.Choice()
  SELF.ListQueue.Fetch(SELF.CurrentChoice)
  self.fields.assignRightToLeft() 

  !Pro:ProductId = Queue:Browse:1.pro:productId
  !get(products, Pro:PK_Products)

  return
! ----------------------------------------------------------------