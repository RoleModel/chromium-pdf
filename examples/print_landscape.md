# Print Landscape

It is possible to dynamically configure a web page to be printed in landscape orientation using scss.

Example:

```scss
  @page landscape {
    size: 11in 8.5in;
  }

  .print-landscape {
    page: landscape;
    .app__content {
      max-width: 100%;
    }
  }
```

This class can then be added conditionally to the body of the application view:

```slim
  body.app-body class="#{'print-landscape' if @print_landscape}"
    = turbo_frame_tag 'modal'
    = render 'confirm'
    ...
```

And this can then be controlled by passing the `@print_landscape` variable from any controller.

## Scaling

Printing in landscape orientation this way effectively scales up the web page compared to portrait orientation. This can be rectified with the following class:

```scss
  .landscape-scale {
    zoom: 0.77; // Letter size difference, 8.5in / 11in = 77%
  }
```