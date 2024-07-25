//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   21 Jul 2024  Andy Frank  Creation
//

@Js abstract class AbstractDxTest : Test
{

//////////////////////////////////////////////////////////////////////////
// Verify Helpers
//////////////////////////////////////////////////////////////////////////

  protected Void verifyRec(DxRec rec, Str:Obj? expect)
  {
    dumb := Str:Obj?[:].setAll(expect)
    test := Str:Obj?[:]
    rec.each |v,k| { test[k] = v }
    verifyEq(test, dumb)
  }

  protected Void verifyBucket(DxStore store, Str bucket, [Str:Obj?][] expect)
  {
    index := 0
    verifyEq(store.size(bucket), expect.size)
    store.each(bucket) |test| { verifyRec(test, expect[index++]) }
  }
}