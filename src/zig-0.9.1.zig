const std = @import("std");
const assert = std.debug.assert;
const math = std.math;
const mem = std.mem;
const testing = std.testing;
const Limb = std.math.big.Limb;
const Const = std.math.big.int.Const;
const Managed = std.math.big.int.Managed;

/// expNnWindowed calculates x**y mod m using a fixed, 4-bit window.
fn expNnWindowed(
    out: *Managed,
    x_abs: Const,
    y_abs: Const,
    m_abs: Const,
) !void {
    const allocator = out.allocator;
    // zz and r are used to avoid allocating in mul and div as otherwise
    // the arguments would alias.
    var zz = try Managed.init(allocator);
    defer zz.deinit();
    var r = try Managed.init(allocator);
    defer r.deinit();

    const n = 4;
    // powers[i] contains x^i.
    var powers = try allocator.alloc(Managed, 1 << n);
    defer {
        for (powers) |*p| p.deinit();
        allocator.free(powers);
    }

    powers[0] = try Managed.initSet(allocator, 1);
    powers[1] = try Managed.init(allocator);
    try powers[1].copy(x_abs);
    var i: usize = 2;
    while (i < powers.len) : (i += 1) {
        powers[i] = try Managed.initSet(allocator, 0);
    }
    i = 2;
    while (i < 1 << n) : (i += 2) {
        var p2 = &powers[i / 2];
        var p = &powers[i];
        var p1 = &powers[i + 1];
        try p.sqr(p2.toConst());
        try zz.divTrunc(&r, p.toConst(), m_abs);
        p.swap(&r);
        try mul(p1, p.toConst(), x_abs);
        try zz.divTrunc(&r, p1.toConst(), m_abs);
        p1.swap(&r);
    }

    var z = try Managed.initSet(allocator, 1);
    defer z.deinit();
    i = y_abs.limbs.len - 1;
    while (i >= 0) : (i -= 1) {
        var yi = y_abs.limbs[i];
        std.log.debug("i={}, yi={}", .{ i, yi });
        var j: usize = 0;
        while (j < @bitSizeOf(Limb)) : (j += n) {
            std.log.debug("j={}, z={}, zz={}", .{ j, z, zz });
            if (i != y_abs.limbs.len - 1 or j != 0) {
                // Unrolled loop for significant performance
                // gain. Use go test -bench=".*" in crypto/rsa
                // to check performance before making changes.
                try zz.sqr(z.toConst());
                zz.swap(&z);
                try zz.divTrunc(&r, z.toConst(), m_abs);
                z.swap(&r);

                try zz.sqr(z.toConst());
                zz.swap(&z);
                try zz.divTrunc(&r, z.toConst(), m_abs);
                z.swap(&r);

                try zz.sqr(z.toConst());
                zz.swap(&z);
                try zz.divTrunc(&r, z.toConst(), m_abs);
                z.swap(&r);

                try zz.sqr(z.toConst());
                zz.swap(&z);
                try zz.divTrunc(&r, z.toConst(), m_abs);
                z.swap(&r);
            }

            try mul(&zz, z.toConst(), powers[yi >> (@bitSizeOf(Limb) - n)].toConst());
            zz.swap(&z);
            try zz.divTrunc(&r, z.toConst(), m_abs);
            z.swap(&r);

            yi <<= n;
        }
        if (i == 0) {
            break;
        }
    }
    z.normalize(z.len());
    out.swap(&z);
}

pub fn mul(out: *Managed, a: Const, b: Const) !void {
    const is_a_alias = a.limbs.ptr == out.limbs.ptr;
    const is_b_alias = b.limbs.ptr == out.limbs.ptr;
    if (is_a_alias or is_b_alias) {
        try out.ensureMulCapacity(a, b);
        var a2 = a;
        var b2 = b;
        if (is_a_alias) a2.limbs.ptr = out.limbs.ptr;
        if (is_b_alias) b2.limbs.ptr = out.limbs.ptr;
        try out.mul(a2, b2);
    } else {
        try out.mul(a, b);
    }
}

test "expNnWindowed" {
    testing.log_level = .debug;
    const f = struct {
        fn f(want: Managed, x: Const, y: Const, m: Const) !void {
            const allocator = want.allocator;
            var got = try Managed.init(allocator);
            defer got.deinit();
            try expNnWindowed(&got, x, y, m);
            try testing.expect(got.eq(want));
        }
    }.f;

    const allocator = testing.allocator;
    {
        var x = try Managed.initSet(
            allocator,
            2938462938472983472983659726349017249287491026512746239764525612965293865296239471239874193284792387498274256129746192347,
        );
        defer x.deinit();
        var y = try Managed.initSet(
            allocator,
            298472983472983471903246121093472394872319615612417471234712061,
        );
        defer y.deinit();
        var m = try Managed.initSet(
            allocator,
            29834729834729834729347290846729561262544958723956495615629569234729836259263598127342374289365912465901365498236492183464,
        );
        defer m.deinit();
        var want = try Managed.initSet(
            allocator,
            23537740700184054162508175125554701713153216681790245129157191391322321508055833908509185839069455749219131480588829346291,
        );
        defer want.deinit();
        try f(want, x.toConst(), y.toConst(), m.toConst());
    }
    {
        @setEvalBranchQuota(10000);

        var x = try Managed.initSet(
            allocator,
            2,
        );
        defer x.deinit();
        var y = try Managed.initSet(
            allocator,
            9247324572804102889565555777311914057954687482673431192869682151395651003606366864848904841770165182604035932529621174486515688424932060959148379649412557,
        );
        defer y.deinit();
        var m = try Managed.initSet(
            allocator,
            21766174458617435773191008891802753781907668374255538511144643224689886235383840957210909013086056401571399717235807266581649606472148410291413364152197364477180887395655483738115072677402235101762521901569820740293149529620419333266262073471054548368736039519702486226506248861060256971802984953561121442680157668000761429988222457090413873973970171927093992114751765168063614761119615476233422096442783117971236371647333871414335895773474667308967050807005509320424799678417036867928316761272274230314067548291133582479583061439577559347101961771406173684378522703483495337037655006751328447510550299250924469288818,
        );
        defer m.deinit();
        var want = try Managed.initSet(
            allocator,
            15192224655675966795304428144150996248285164724029282922119477226522730055011798030162416758996331356314724744317539931061814981258588111512177401900495710673973552425181964932219365697029109211391427241439656399069061552176206812918451626814158901404051706172888115076402399621576360236600706808505758010289601435388412442610143977840304053897511685030387783236416903461083937152000440647686990201444871560575082331986319377899501231404479527464852744285685494300197469317282302361118318425620239197583560262218774074152110447819795968790357840034014149304193870867253747490521063979438299908542428375573520814017354,
        );
        defer want.deinit();
        try f(want, x.toConst(), y.toConst(), m.toConst());
    }
}
