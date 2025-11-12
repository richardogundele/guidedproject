const express = require('express');
    const os = require('os');
    const app = express();
    const port = process.env.PORT || 8080; // App Service uses PORT variable

    app.use(express.json());

    // Basic API endpoint to check health and tier isolation
    app.get('/api/status', (req, res) => {
      // The client IP (req.ip) should be the VNet's internal address, 
      // proving the Web Tier passed the request internally.
      res.status(200).json({
        message: 'Successfully reached Application Tier!',
        source_ip: req.ip || 'Unknown (Check Request Headers)',
        hostname: os.hostname()
      });
    });

    app.listen(port, () => {
      console.log(`Backend App listening at port ${port}`);
    });