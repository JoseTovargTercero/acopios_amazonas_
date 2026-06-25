<!DOCTYPE html>
<html lang="en" data-topbar-color="dark">

<?php include __DIR__ . '/../partials/head.php'; ?>


<body class="loading"
    data-layout-config='{"leftSideBarTheme":"dark","layoutBoxed":false, "leftSidebarCondensed":false, "leftSidebarScrollable":false,"darkMode":false, "showRightSidebarOnStart": true}'>

    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            <!-- Menu -->
            <!-- ========== Menu ========== -->
            <?php include __DIR__ . '/../partials/sidebar.php'; ?>
            <!-- ========== Left menu End ========== -->

            <!-- ============================================================== -->
            <!-- Start Page Content here -->
            <!-- ============================================================== -->
            <div class="layout-page">

                <?php include __DIR__ . '/../partials/topbar.php' ?>
                <!-- ========== Topbar End ========== -->
                <div class="content pt-2">
                    <!-- Start Content-->
                    <?php echo $content; ?>
                    <!-- container -->
                </div> <!-- content -->
                <?php include __DIR__ . '/../partials/footer.php' ?>
            </div>
        </div>
        <!-- ============================================================== -->
        <!-- End Page content -->
        <!-- ============================================================== -->
    </div>
    <!-- END wrapper -->
    <!-- Theme Settings -->





</body>

</html>