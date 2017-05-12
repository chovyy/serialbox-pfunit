MODULE serialbox_test
   
  USE ISO_FORTRAN_ENV
  USE pfunit_mod
  USE m_serialize
  
  IMPLICIT NONE
  
  PUBLIC 

  TYPE(t_savepoint)  :: savepoint

CONTAINS

!@Before
   SUBROUTINE mySetup()

      CALL fs_create_savepoint('test', savepoint)
      
   END SUBROUTINE mySetup
   
!@After
   SUBROUTINE myTearDown()

      CALL fs_destroy_savepoint(savepoint)
      
   END SUBROUTINE myTearDown
   
!@Test
    SUBROUTINE testSerializer()
    
      TYPE(t_serializer) :: serializer
      INTEGER :: w_testfield_i1(5), r_testfield_i1(5)
      
      w_testfield_i1 = (/ 0, 1, 2, 3, 4 /)
            
      CALL fs_create_serializer("sbdata", 'test', 'w', serializer)
      CALL fs_write_field(serializer, savepoint, "testfield_i1", w_testfield_i1)
      CALL fs_destroy_serializer(serializer)
      
      CALL fs_create_serializer("sbdata", 'test', 'r', serializer)
      CALL fs_read_field(serializer, savepoint, "testfield_i1", r_testfield_i1)
      CALL fs_destroy_serializer(serializer)
      
#line 45 "serialbox_test.pf"
  call assertEqual(w_testfield_i1, r_testfield_i1, &
 & location=SourceLocation( &
 & 'serialbox_test.pf', &
 & 45) )
  if (anyExceptions()) return
#line 46 "serialbox_test.pf"
    
    END SUBROUTINE testSerializer

END MODULE serialbox_test



module Wrapserialbox_test
   use pFUnit_mod
   use serialbox_test
   implicit none
   private

contains


end module Wrapserialbox_test

function serialbox_test_suite() result(suite)
   use pFUnit_mod
   use serialbox_test
   use Wrapserialbox_test
   type (TestSuite) :: suite

   suite = newTestSuite('serialbox_test_suite')

   call suite%addTest(newTestMethod('testSerializer', testSerializer, mySetup, myTearDown))


end function serialbox_test_suite

