//
// Copyright (c) 2025, Novant LLC
// All Rights Reserved
//
// History:
//   27 Feb 2025  Andy Frank  Creation
//

@Js class DxWriterTest : AbstractDxTest
{

//////////////////////////////////////////////////////////////////////////
// Add Bucket
//////////////////////////////////////////////////////////////////////////

  Void testAddBucket()
  {
    a := DxStore(1, ["foo":[
      DxRec(["id":1, "a":12, "b":"foo", "c":false]),
      DxRec(["id":2, "a":24, "b":"bar", "c":true]),
      DxRec(["id":3, "a":18, "b":"zar", "c":false]),
    ]])

     // add a new bucke
    w := DxWriter(a)
    w.addBucket("new_bucket")
    b := w.commit
    verify(a !== b)
    verifyEq(a.version, 1)
    verifyEq(b.version, 2)
    verifyEq(a.buckets.sort, ["foo"])
    verifyEq(b.buckets.sort, ["foo", "new_bucket"])
    verifyEq(b.size("new_bucket"), 0)

    // add recs to new bucket
    w = DxWriter(b)
    w.add("new_bucket", ["id":1, "name":"R1"])
    w.add("new_bucket", ["id":2, "name":"R2"])
    c := w.commit
    verifyEq(c.version, 3)
    verifyEq(c.size("new_bucket"), 2)
    verifyRec(c.get("new_bucket", 1), ["id":1, "name":"R1"])
    verifyRec(c.get("new_bucket", 2), ["id":2, "name":"R2"])
  }
}